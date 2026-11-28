"""Run a two-boot OverlayFS test on a disposable QEMU USB device."""
import os
from pathlib import Path
import selectors
import shlex
import subprocess
import sys
import tempfile
import time

PASSWORD_HASH = subprocess.check_output(
    ["openssl", "passwd", "-6", "-salt", "majix-ci", "disposable-test-password"], text=True,
).strip()
BOOT = (
    "boot=live components hostname=majix username=majix locales=en_US.UTF-8 "
    "nox11autologin noeject zswap.enabled=0 quickusbmodules persistence persistence-media=removable-usb "
    "persistence-storage=filesystem persistence-encryption=none persistence-label=MAJIX_DATA "
    "systemd.unit=multi-user.target systemd.debug_shell=ttyS0 "
    "systemd.mask=serial-getty@ttyS0.service"
)

WRITE = f"""
majix-storage --require-full
test "$(id -u majix)" = 1000
runuser -u majix -- mkdir -p /home/majix/.config
echo 'portable-project' >/home/majix/portable-project
printf '[General]\nColorScheme=BreezeDark\n' >/home/majix/.config/kdeglobals
useradd -m majix-ci
printf '%s\n' {shlex.quote('majix-ci:' + PASSWORD_HASH)} | chpasswd -e
mkdir -p /tmp/majix-fixture/DEBIAN /tmp/majix-fixture/usr/share/majix
printf 'Package: majix-ci-fixture\nVersion: 1.0.0\nArchitecture: all\nMaintainer: MAJIX CI <ci@example.invalid>\nDescription: Reboot test\n' >/tmp/majix-fixture/DEBIAN/control
echo 'installed' >/tmp/majix-fixture/usr/share/majix/ci-fixture
dpkg-deb --build /tmp/majix-fixture /tmp/majix-fixture.deb
dpkg --install /tmp/majix-fixture.deb
sync
"""
VERIFY = f"""
majix-storage --require-full
grep -Fx portable-project /home/majix/portable-project
grep -Fx ColorScheme=BreezeDark /home/majix/.config/kdeglobals
id majix-ci
test "$(getent shadow majix-ci | cut -d: -f2)" = {shlex.quote(PASSWORD_HASH)}
test "$(dpkg-query -W -f='${{db:Status-Status}}' majix-ci-fixture)" = installed
grep -Fx installed /usr/share/majix/ci-fixture
"""


def boot(iso, kernel, initrd, usb, script, *, require_shutdown=True):
    # A root debug shell is enabled only via this test VM's kernel command line.
    args = [
        "qemu-system-x86_64", "-machine", "accel=kvm:tcg", "-m", "3072", "-smp", "2",
        "-nic", "none", "-display", "none", "-monitor", "none", "-no-reboot",
        "-serial", "stdio", "-kernel", kernel, "-initrd", initrd, "-append", BOOT,
        "-cdrom", iso, "-device", "qemu-xhci",
        "-drive", f"if=none,id=data,format=raw,file={usb}", "-device", "usb-storage,drive=data,removable=on",
    ]
    command = (
        "while ! systemctl is-active --quiet multi-user.target; do sleep 1; done; "
        f"printf %s {shlex.quote(script.encode().hex())} | "
        "python3 -c 'import sys; sys.stdout.buffer.write(bytes.fromhex(sys.stdin.read()))' "
        "> /run/majix-ci.sh; "
        "if sh -e /run/majix-ci.sh; then printf '\\nMAJIX_CI_%s\\n' OK; "
        "else printf '\\nMAJIX_CI_%s\\n' FAIL; fi; systemctl poweroff\n"
    )
    with subprocess.Popen(args, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.STDOUT) as vm:
        try:
            with selectors.DefaultSelector() as selector:
                selector.register(vm.stdout, selectors.EVENT_READ)
                deadline = time.monotonic() + 210
                log = bytearray()
                sent = False
                while time.monotonic() < deadline:
                    if not selector.select(timeout=1):
                        continue
                    chunk = os.read(vm.stdout.fileno(), 65536)
                    if not chunk:
                        break
                    log.extend(chunk)
                    # The first guest must shut down cleanly before the next
                    # boot. The last guest only verifies a disposable image.
                    if sent and not require_shutdown and b"MAJIX_CI_OK" in log:
                        print(log.decode(errors="replace"))
                        return
                    if not sent and b"# " in log:
                        vm.stdin.write(command.encode())
                        vm.stdin.flush()
                        sent = True
            print(log.decode(errors="replace"))
            if vm.wait(timeout=10) != 0 or b"MAJIX_CI_OK" not in log:
                raise RuntimeError("La prueba de persistencia no se completó")
        finally:
            if vm.poll() is None:
                vm.kill()


def main(iso, kernel, initrd):
    with tempfile.TemporaryDirectory(prefix="majix-persistence-") as directory:
        path = Path(directory)
        root = path / "filesystem"
        root.mkdir()
        (root / "persistence.conf").write_text("/ union\n")
        disk = path / "data.img"
        with disk.open("wb") as image:
            image.truncate(512 * 1024**2)
        subprocess.run(["mke2fs", "-q", "-t", "ext4", "-L", "MAJIX_DATA", "-d", root, disk], check=True)
        boot(iso, kernel, initrd, disk, WRITE)
        boot(iso, kernel, initrd, disk, VERIFY, require_shutdown=False)


if __name__ == "__main__":
    main(*sys.argv[1:])
