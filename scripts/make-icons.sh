#!/usr/bin/env bash
# Rasterise public/favicon.svg into public/apple-touch-icon.png (180) and public/favicon.ico (32).
# Usage: scripts/make-icons.sh   (macOS: uses sips)
set -euo pipefail
cd "$(dirname "$0")/../public"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# iOS masks touch icons itself, so give it a square, fully opaque background.
sed 's/<rect width="32" height="32" rx="6"/<rect width="32" height="32"/' favicon.svg > "$TMP/square.svg"
sips -s format png -z 180 180 "$TMP/square.svg" --out apple-touch-icon.png >/dev/null
sips -s format png -z 32 32 favicon.svg --out "$TMP/32.png" >/dev/null

# An .ico may hold a PNG directly: 6-byte header + one 16-byte directory entry + the PNG.
python3 - "$TMP/32.png" favicon.ico <<'PY'
import struct, sys
png = open(sys.argv[1], "rb").read()
ico = struct.pack("<HHH", 0, 1, 1) + struct.pack("<BBBBHHII", 32, 32, 0, 0, 1, 32, len(png), 22) + png
open(sys.argv[2], "wb").write(ico)
PY

echo "wrote public/apple-touch-icon.png, public/favicon.ico"
