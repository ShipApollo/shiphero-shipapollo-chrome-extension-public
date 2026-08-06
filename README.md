# ShipHero Lookup — update distribution

This repo holds only the **signed CRX3 package** (`latest.crx`) and **Chrome update
manifest** (`update-manifest.xml`) for the [ShipHero Lookup Chrome
extension](https://github.com/ShipApollo/shiphero-lookup-extension). It contains no
source code.

It exists so that `raw.githubusercontent.com` can serve these two files without
authentication, which Chrome's built-in extension updater requires. Company-managed
devices install and auto-update the extension via Intune's `ExtensionInstallForcelist`
policy pointed at `update-manifest.xml` in this repo — see the source repo's README
("Self-hosted updates for company-managed devices (Intune)") for full details.

Both files here are regenerated and pushed automatically by the source repo's
`release.yml` workflow on every version bump. Do not edit them by hand.
