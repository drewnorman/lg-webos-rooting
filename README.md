# LG 50UK6090PUA webOS rooting

Working record and tooling for Drew's LG 50UK6090PUA. The TV reported firmware **05.50.70** before this work. The exact webOS version is still to be confirmed from the device.

The selected method is [throwaway96/faultmanager-autoroot](https://github.com/throwaway96/faultmanager-autoroot). Its author says it roots supported webOS 4.0+ TVs and installs Homebrew Channel. Drew checked [CanI.RootMy.TV for this model and firmware](https://cani.rootmy.tv/?q=50UK6090PUA%2005.50.70) and reported that faultmanager lists `05.50.70` as the latest known rootable firmware. Recheck the actual TV firmware before running anything; firmware updates can change compatibility.

## Current state

- LG developer account created; Developer Mode app signed in.
- Dev Mode Status enabled, TV rebooted, and Key Server started with its screen open, per Drew's latest report.
- TV and this NixOS laptop are on the same network.
- Pairing, live system information, and rooting results should be recorded here as they happen. No exploit result is recorded yet.

## Working environment on the laptop

```bash
cd lg-webos-rooting
direnv allow        # or: nix develop
just install        # install the pinned @webos-tools/cli dependency
just check          # show CLI version
```

The flake provides the command-line tools; `yarn install --frozen-lockfile` supplies LG's CLI from the lockfile. LG's [published CLI system requirements](https://webostv.developer.lge.com/develop/tools/cli-installation) list Ubuntu for Linux and recommend older Node releases. This NixOS setup is a local workflow, not an officially supported LG configuration.

## Connect to Developer Mode

These commands run **on the laptop**. Leave the Developer Mode app's Key Server screen open on the TV. Follow [LG's connection instructions](https://webostv.developer.lge.com/develop/getting-started/developer-mode-app).

1. Run `just register` and choose **add**. Name the device `lg`, enter the TV's current IP address, port `9922`, SSH user `prisoner`, a blank password, and set it as the default device.
2. Run `just key`. Enter the six-character, case-sensitive passphrase shown on the TV **at the local prompt**.
3. Run `just info` and record the model, firmware, and SDK/webOS information in a session note.

For a direct SSH shell, use the private key path reported by `ares-novacom --getkey`:

```bash
ssh -i /path/reported/by/getkey -p 9922 prisoner@TV_IP
```

If current OpenSSH refuses the TV's older RSA algorithms, the [maintainer's SSH guide](https://gist.github.com/throwaway96/e811b0f7cc2a705a5a476a8dfa45e09f) suggests adding `-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa` for this connection. Inspect the first host key prompt before accepting it. A `PTY allocation request failed` message may still leave a usable command shell.

## Rooting procedure

Review the [current upstream README](https://github.com/throwaway96/faultmanager-autoroot) and the vendored `vendor/faultmanager-autoroot/autoroot.sh` before execution. The vendored script is from upstream commit `a972c95f4f4dbacdb72215409ea0c9eff39dabc1` (2026-03-01) and has SHA-256 `66a8a2816567a3c3d29768095873d347ec6bb2cbf60208979d15d7a42525d4d0`. The Homebrew Channel v0.7.3 IPK has SHA-256 `d10bf3c753551d7c72fb7a92b20fcd2317e502a220ac668ba8e76f6ea78b363c`. See `vendor/faultmanager-autoroot/PROVENANCE.md` for origins; the upstream license is in `COPYING` there.

Download the pinned script and Homebrew Channel IPK to the **TV** through the paired Developer Mode CLI, then compare both hashes with those above:

```bash
yarn ares-novacom --device lg --run 'curl -fL -o /tmp/autoroot.sh -- https://raw.githubusercontent.com/throwaway96/faultmanager-autoroot/a972c95f4f4dbacdb72215409ea0c9eff39dabc1/autoroot.sh && sha256sum /tmp/autoroot.sh'
yarn ares-novacom --device lg --run 'curl -fL -o /tmp/hbchannel.ipk -- https://github.com/webosbrew/webos-homebrew-channel/releases/download/v0.7.3/org.webosbrew.hbchannel_0.7.3_all.ipk && sha256sum /tmp/hbchannel.ipk'
```

Proceed only if both TV hashes match. Then run it in the **TV's SSH shell**:

```sh
sh /tmp/autoroot.sh
```

The upstream sequence is: place the script in a writable TV directory, run it, wait for `Payload complete` and the script to exit, then **uninstall LG's Developer Mode app before rebooting**. Do not install that app again while the TV is rooted. The script installs the verified Homebrew Channel v0.7.3 IPK from `/tmp`. Avoid the optional `--telnet` flag unless it is deliberately needed; it exposes a root shell on port 23.

Before the run, turn off automatic firmware updates and Quick Start+ in the TV settings. A later firmware update may patch the exploit or affect persistence. Do not change the service menu's NSU Mode.

After the script exits, preserve its result and the `autoroot.log` / `autoroot-payload.log` paths if available. Confirm the Developer Mode app is removed **before** any reboot. Then reboot and check for Homebrew Channel. The Developer Mode SSH service on port `9922` belongs to the app and should not be assumed available after uninstalling it.

## If something goes wrong

- A segmentation fault during the exploit is expected by its author. Judge success by the full script output, not that line alone.
- If Homebrew Channel does not appear after a reported success, confirm Quick Start+ is disabled and reboot, after uninstalling Developer Mode.
- For a Homebrew Channel installation error such as `errorCode -5`, check the TV date.
- Save the two upstream log files for diagnosis.
- Check the current [compatibility checker](https://cani.rootmy.tv/?q=50UK6090PUA%2005.50.70) and [upstream troubleshooting section](https://github.com/throwaway96/faultmanager-autoroot#troubleshooting) before considering another attempt.

Root allows homebrew and system customization. Changes to startup services or a replacement launcher need separate compatibility checks for this older TV. The [webOS Homebrew rooting overview](https://www.webosbrew.org/rooting/) describes what root adds relative to Developer Mode.

## Repository contents

- `flake.nix`, `flake.lock`, `.envrc`: Nix/direnv environment.
- `package.json`, `yarn.lock`: pinned LG webOS CLI.
- `justfile`: common laptop commands.
- `vendor/faultmanager-autoroot/`: reviewed script, provenance, and upstream license.
- [`docs/links.md`](docs/links.md): primary sources and future reference links.
- [`docs/session-template.md`](docs/session-template.md): record for each TV work session.

Record each device session's results in a separate note. The pinned script and license are kept here so future sessions use the reviewed revision.

## License

Project-authored documentation and tooling are [MIT licensed](LICENSE). The vendored faultmanager source retains its [AGPL-3.0-or-later license](vendor/faultmanager-autoroot/COPYING). The Homebrew Channel IPK is downloaded from upstream; it is not distributed in this repository.
