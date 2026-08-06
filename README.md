# ShipHero Lookup — update distribution

This repo holds only generated distribution files for the [ShipHero Lookup Chrome
extension](https://github.com/ShipApollo/shiphero-lookup-extension). It contains no
source code. Everything here is regenerated and pushed automatically by the source
repo's `release.yml` workflow on every version bump — don't edit these files by hand.

| File                                  | Used by                                                                                                                                                                       |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `latest.crx` + `update-manifest.xml`   | Company-managed (Intune) devices, via `ExtensionInstallForcelist` pointed at `update-manifest.xml`. Chrome installs/updates silently.                                        |
| `latest.zip` + `update-extension.bat`  | Anyone using "Load unpacked" (Developer mode) manually. Run `update-extension.bat` to install or update — see the source repo's README ("Manual update script") for details. |

This repo is public (not the source code) specifically so `raw.githubusercontent.com`
can serve these files without authentication, which both Chrome's built-in updater and
the manual `.bat` script require.
