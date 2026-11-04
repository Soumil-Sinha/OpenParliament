#!/bin/sh
#
# Regenerates db/seed.sql from the app's bundled Swift fixtures, so the
# database and the app's offline data never drift apart.
#
set -eu

HERE="$(cd "$(dirname "$0")" && pwd)"
APP="$HERE/../../OpenParliament"
BUILD="$(mktemp -d)"

# Top-level code is only allowed in a file named main.swift.
cp "$HERE/GenerateSeed.swift" "$BUILD/main.swift"
xcrun swiftc -o "$BUILD/generate-seed" \
    "$BUILD/main.swift" "$APP"/Models/*.swift "$APP"/Data/Fixture.swift "$APP"/Data/Sample*.swift

"$BUILD/generate-seed" > "$HERE/../db/seed.sql"
rm -rf "$BUILD"
echo "Wrote db/seed.sql"
