# Cirorx Homebrew tap

Casks for the Mac apps on [ciroapps.com](https://ciroapps.com):

```
brew trust cirorx/tap
brew install --cask cirorx/tap/droidview
brew install --cask cirorx/tap/quire
```

Homebrew 7 loads casks from a third-party tap only once you trust it, hence the first line.

| cask | app | also installs |
|---|---|---|
| `droidview` | DroidView: the Android emulator in one window, with developer tools and an MCP server | `droidview` (`droidview --mcp` is the MCP server) |
| `quire` | Quire: a PDF reader that stays responsive on huge books and scans | `quire`, the command line reader |

Both need an Apple Silicon Mac. They are not notarized yet, so each cask clears the download's
quarantine flag after installing; without that, macOS refuses to open the app.

## Releasing

The zips are served from ciroapps.com (the site repo's `public/downloads`), not from this repo.
With the app's version bumped in its `Info.plist`:

```
scripts/release.sh droidview     # or quire
```

That builds the app, zips it into the site's `public/downloads/<App>-<version>.zip` and
writes the version and SHA-256 into the cask. Push the site first (the zip has to be live
before anyone installs), then this repo.
