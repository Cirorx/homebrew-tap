cask "droidview" do
  version "0.1.2"
  sha256 "512216d648ed8eed6f7d13d21abe3ac1f9662a57c18e188c724958992933f3a3"

  url "https://ciroapps.com/downloads/DroidView-#{version}.zip"
  name "DroidView"
  desc "Android emulator in one window, with developer tools and an MCP server"
  homepage "https://ciroapps.com/"

  depends_on arch: :arm64
  depends_on macos: :ventura

  app "DroidView.app"
  binary "#{appdir}/DroidView.app/Contents/MacOS/DroidView", target: "droidview"

  # Not notarized: without this macOS refuses to open the downloaded app.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/DroidView.app"]
  end

  zap trash: [
    "~/Library/Application Support/droidview",
    "~/Library/Preferences/dev.droidview.mac.plist",
    "~/Library/Saved Application State/dev.droidview.mac.savedState",
  ]

  caveats <<~EOS
    DroidView runs the Android SDK's emulator: install Android Studio (or the SDK) and create an
    AVD in its Device Manager. For the scrcpy video path, also: brew install scrcpy

    To let Claude Code see and drive the device:
      claude mcp add --scope user droidview -- #{HOMEBREW_PREFIX}/bin/droidview --mcp
  EOS
end
