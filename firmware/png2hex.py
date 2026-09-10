import sys
from PIL import Image

if len(sys.argv) < 2:
    print("Usage: python3 png2hex.py <input_image> [width] [height] [output.hex]")
    sys.exit(1)

img_path = sys.argv[1]
width    = int(sys.argv[2]) if len(sys.argv) > 2 else 512
height   = int(sys.argv[3]) if len(sys.argv) > 3 else 512
out_path = sys.argv[4] if len(sys.argv) > 4 else "input.hex"

img = Image.open(img_path).convert("L").resize((width, height))
pixels = list(img.getdata())

with open(out_path, "w") as f:
    for p in pixels:
        f.write(f"{p:02x}\n")

print(f"Wrote {len(pixels)} pixels ({width}x{height}) to {out_path}")
