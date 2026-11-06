#!/bin/bash
# Builds one app, zips it into ciroapps-site/public/downloads, and points its cask at the new zip
# (version and SHA-256). The site and app repos are expected to sit next to this one.
#
#   scripts/release.sh droidview
#   scripts/release.sh quire
#   scripts/release.sh reclaim
#
# Then commit and push the zip in ciroapps-site (which deploys it), and after that the cask here.
set -euo pipefail

tap="$(cd "$(dirname "$0")/.." && pwd)"
coding="$(dirname "${tap}")"
downloads="${coding}/ciroapps-site/public/downloads"

case "${1:-}" in
  droidview)
    (cd "${coding}/desktop apps/droidview" && macos/build.sh)
    app="${coding}/desktop apps/droidview/macos/build/DroidView.app"
    ;;
  quire)
    (cd "${coding}/desktop apps/quire" && scripts/build-app.sh)
    app="${coding}/desktop apps/quire/build/Quire.app"
    ;;
  reclaim)
    (cd "${coding}/desktop apps/Reclaim" && ./build.sh --release)
    app="${coding}/desktop apps/Reclaim/dist/Reclaim.app"
    ;;
  *)
    echo "usage: $0 droidview|quire|reclaim" >&2
    exit 2
    ;;
esac

name="$(basename "${app}" .app)"
version="$(/usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" "${app}/Contents/Info.plist")"
zip="${downloads}/${name}-${version}.zip"
mkdir -p "${downloads}"
rm -f "${zip}"
# ditto keeps the bundle's symlinks, permissions and signature intact. No --sequesterRsrc: its
# __MACOSX folder of AppleDouble files breaks signature checks and stapling once notarized.
ditto -c -k --keepParent "${app}" "${zip}"
sha="$(shasum -a 256 "${zip}" | cut -d' ' -f1)"

cask="${tap}/Casks/$1.rb"
sed -i '' -E "s/^  version \".*\"/  version \"${version}\"/; s/^  sha256 \".*\"/  sha256 \"${sha}\"/" "${cask}"
echo "${zip} ($(du -h "${zip}" | cut -f1))"
echo "${cask}: version ${version}, sha256 ${sha}"
