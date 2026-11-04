#!/bin/sh
# Exports poster.html to PDF (print size) and PNG (preview) with headless Chrome.
set -eu
HERE="$(cd "$(dirname "$0")" && pwd)"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
"$CHROME" --headless=new --disable-gpu --no-pdf-header-footer \
    --print-to-pdf="$HERE/OpenParliament Poster.pdf" "file://$HERE/poster.html" 2>/dev/null
"$CHROME" --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 \
    --window-size=2000,2828 --screenshot="$HERE/OpenParliament Poster.png" "file://$HERE/poster.html" 2>/dev/null
echo "Exported poster PDF and PNG"
