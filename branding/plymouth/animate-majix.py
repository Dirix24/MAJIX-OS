"""Render a short looping pulse of the original MAJIX emblem."""
import math
from pathlib import Path
import sys

from PIL import Image, ImageEnhance, ImageFilter

SIZE = 224
FRAMES = 24


def render(destination):
    logo_path = Path(__file__).with_name("watermark.png")
    with Image.open(logo_path) as source:
        logo = source.convert("RGBA")

    for index in range(FRAMES):
        phase = math.tau * index / FRAMES
        pulse = (1 - math.cos(phase)) / 2
        scale = 1 + 0.10 * pulse
        size = tuple(round(value * scale) for value in logo.size)
        emblem = logo.resize(size, Image.Resampling.LANCZOS)
        light = ImageEnhance.Brightness(emblem).enhance(1 + 0.24 * pulse)
        offset = tuple((SIZE - value) // 2 for value in size)

        lit = Image.new("RGBA", (SIZE, SIZE))
        lit.paste(light, offset)
        glow = lit.filter(ImageFilter.GaussianBlur(6))
        alpha = glow.getchannel("A").point(lambda value: int(value * (0.4 + 0.5 * pulse)))
        glow.putalpha(alpha)
        frame = Image.alpha_composite(glow, lit)
        frame.save(destination / f"throbber-{index + 1:04d}.png")


if __name__ == "__main__":
    render(Path(sys.argv[1]))
