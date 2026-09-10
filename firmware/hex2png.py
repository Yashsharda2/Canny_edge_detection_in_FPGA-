import sys
from PIL import Image

if len(sys.argv) != 4:
    print("Usage: python3 hex2png.py <hexfile> <width> <height>")
    sys.exit(1)

path, w, h = sys.argv[1], int(sys.argv[2]), int(sys.argv[3])

with open(path) as f:
    data = [int(line.strip(), 16) for line in f if line.strip()]

expected = w * h
if len(data) != expected:
    print(f"WARNING: got {len(data)} bytes, expected {expected} (w*h). ")

img = Image.new("L", (w, h))
img.putdata(data[:expected])
img.save("output.png")
print("Saved output.png")
