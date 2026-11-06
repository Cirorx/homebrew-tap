cask "reclaim" do
  version "1.2.0"
  sha256 "16123036231bed1c0762ae9b529d38bb3b072059ac7535f9c74f417ae23b858a"

  url "https://ciroapps.com/downloads/Reclaim-#{version}.zip"
  name "Reclaim"
  desc "Finds and reclaims regenerable developer disk space"
  homepage "https://ciroapps.com/"

  # Universal binary, so no arch constraint.
  depends_on macos: :sonoma

  app "Reclaim.app"

  # Not notarized: without this macOS refuses to open the downloaded app.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Reclaim.app"]
  end

  # Preferences and the scan history. Everything in it is regenerable, the same
  # standard the app applies to what it deletes.
  zap trash: [
    "~/Library/Application Support/Reclaim",
    "~/Library/Caches/com.cirorx.reclaim",
    "~/Library/HTTPStorages/com.cirorx.reclaim",
    "~/Library/Preferences/com.cirorx.reclaim.plist",
    "~/Library/Saved Application State/com.cirorx.reclaim.savedState",
  ]
end
