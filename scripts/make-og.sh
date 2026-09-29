#!/usr/bin/env bash
# Render public/og.png (1200×630) from a frozen frame of public/index.html using headless Chrome.
# Usage: scripts/make-og.sh [reveal 0..1] [time s] [tile css px] [palette]
set -euo pipefail
cd "$(dirname "$0")/../public"

REVEAL="${1:-1}"
TIME="${2:-9}"
TILE="${3:-7}"
PALETTE="${4:-dusk}"
CHROME="${CHROME:-/Applications/Google Chrome.app/Contents/MacOS/Google Chrome}"

# Headless Chrome's viewport is ~87px shorter than its window, so ask for a taller window
# (giving a 1200×630 viewport) and crop the screenshot to it.
"$CHROME" --headless=new --use-angle=swiftshader --enable-unsafe-swiftshader \
  --hide-scrollbars --window-size=1200,717 --virtual-time-budget=3000 \
  --screenshot="$PWD/og.png" \
  "file://$PWD/index.html?still=$REVEAL&t=$TIME&tile=$TILE&palette=$PALETTE" 2>/dev/null
sips -c 630 1200 --cropOffset 0 0 og.png >/dev/null

echo "wrote public/og.png (reveal=$REVEAL t=$TIME tile=$TILE palette=$PALETTE)"
