#!/usr/bin/env bash
# Render og.png (1200×630) from a frozen frame of index.html using headless Chrome.
# Usage: ./make-og.sh [reveal 0..1] [time s] [tile css px]
set -euo pipefail
cd "$(dirname "$0")"

REVEAL="${1:-1}"
TIME="${2:-9}"
TILE="${3:-7}"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"

"$CHROME" --headless=new --use-angle=swiftshader --enable-unsafe-swiftshader \
  --hide-scrollbars --window-size=1200,630 --virtual-time-budget=3000 \
  --screenshot="$PWD/og.png" \
  "file://$PWD/index.html?still=$REVEAL&t=$TIME&tile=$TILE" 2>/dev/null

echo "wrote og.png (reveal=$REVEAL t=$TIME tile=$TILE)"
