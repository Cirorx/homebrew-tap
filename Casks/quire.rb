cask "quire" do
  version "1.0.0"
  sha256 "0325f1e7184ddfcea6922a4fef6179061331886322133f526da46c1df7b7b5c9"

  url "https://ciroapps.com/downloads/Quire-#{version}.zip"
  name "Quire"
  desc "PDF reader that stays responsive on huge books and scans"
  homepage "https://ciroapps.com/"

  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Quire.app"
  binary "#{appdir}/Quire.app/Contents/MacOS/quire-cli", target: "quire"

  # Not notarized: without this macOS refuses to open the downloaded app.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Quire.app"]
  end

  zap trash: [
    "~/Library/Caches/com.cirorx.quire",
    "~/Library/Preferences/com.cirorx.quire.plist",
    "~/Library/Saved Application State/com.cirorx.quire.savedState",
  ]

  caveats <<~EOS
    To make Quire the default PDF reader: select a PDF in the Finder, press Cmd+I, choose Quire
    under "Open with", then "Change All...".
  EOS
end
