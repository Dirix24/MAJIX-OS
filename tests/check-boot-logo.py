"""Boot the ISO from its BIOS menu and look for the animated MAJIX logo."""
import json
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import time


def execute(stream, command, **arguments):
    request = {"execute": command, "arguments": arguments}
    stream.write(json.dumps(request).encode() + b"\n")
    while line := stream.readline():
        response = json.loads(line)
        if "error" in response:
            raise RuntimeError(response["error"])
        if "return" in response:
            return response["return"]
    raise RuntimeError("QEMU closed the monitor connection")


def check_logo(iso, screenshot):
    with tempfile.TemporaryDirectory(prefix="majix-qemu-") as directory:
        monitor = Path(directory, "monitor")
        vga = Path(directory, "frame.ppm")
        vm = subprocess.Popen([
            "qemu-system-x86_64", "-machine", "accel=kvm:tcg",
            "-m", "3072", "-smp", "2", "-nic", "none",
            "-vga", "std", "-display", "none", "-serial", "none",
            "-boot", "d", "-cdrom", str(iso), "-no-reboot",
            "-qmp", f"unix:{monitor},server=on,wait=off",
        ])
        try:
            deadline = time.monotonic() + 210
            while not monitor.exists():
                if vm.poll() is not None or time.monotonic() >= deadline:
                    raise RuntimeError("QEMU did not start")
                time.sleep(0.1)
            with socket.socket(socket.AF_UNIX) as connection:
                connection.settimeout(5)
                connection.connect(str(monitor))
                with connection.makefile("rwb", buffering=0) as stream:
                    json.loads(stream.readline())
                    execute(stream, "qmp_capabilities")
                    time.sleep(4)
                    # Select the default Live entry in Syslinux.
                    for attempt in range(4):
                        execute(stream, "human-monitor-command", **{"command-line": "sendkey ret"})
                        if attempt < 3:
                            time.sleep(1)
                    first_frame = None
                    while time.monotonic() < deadline:
                        execute(stream, "screendump", filename=str(vga))
                        pixels = vga.read_bytes()
                        # The teal mark is unique to this splash and occupies
                        # thousands of pixels at the default VM resolution.
                        if pixels.count(bytes.fromhex("66e5d1")) > 300:
                            if first_frame is None:
                                first_frame = pixels
                                screenshot.write_bytes(pixels)
                            elif pixels != first_frame:
                                print("MAJIX OS logo and moving Plymouth frames detected")
                                return
                        time.sleep(0.15)
            if vga.exists():
                Path(iso.parent, "last-boot-frame.ppm").write_bytes(vga.read_bytes())
            raise RuntimeError("The VM did not display the animated MAJIX OS logo")
        finally:
            if vm.poll() is None:
                vm.terminate()
            vm.wait(timeout=10)


if __name__ == "__main__":
    check_logo(Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve())
