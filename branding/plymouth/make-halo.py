"""Generate the cyan and violet Plymouth halo around the existing MAJIX logo."""
import math
from pathlib import Path
import struct
import sys
import zlib

SIZE = 224
FRAMES = 30


def chunk(kind, data):
    return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))


def main(destination):
    pixels = []
    for y in range(SIZE):
        for x in range(SIZE):
            dx, dy = x - (SIZE - 1) / 2, y - (SIZE - 1) / 2
            distance = math.hypot(dx, dy)
            angle = math.atan2(dy, dx)
            color = (1 + math.sin(angle)) / 2
            pixels.append((distance, angle, (int(75 + color * 90), int(224 - color * 119), 246)))

    for frame in range(FRAMES):
        phase = math.tau * frame / FRAMES
        raster = bytearray()
        for y in range(SIZE):
            raster.append(0)
            for radius, angle, rgb in pixels[y * SIZE:(y + 1) * SIZE]:
                glow = math.exp(-((radius - 91 - 2 * math.sin(phase)) / 5) ** 2)
                brightness = 0.28 + 0.72 * ((1 + math.cos(angle - phase)) / 2) ** 3
                raster.extend((*rgb, int(230 * glow * brightness)))
        header = struct.pack(">IIBBBBB", SIZE, SIZE, 8, 6, 0, 0, 0)
        png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", header)
        png += chunk(b"IDAT", zlib.compress(raster)) + chunk(b"IEND", b"")
        (destination / f"throbber-{frame + 1:04d}.png").write_bytes(png)


if __name__ == "__main__":
    main(Path(sys.argv[1]))
