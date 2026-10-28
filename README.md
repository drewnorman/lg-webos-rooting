# LG 50UK6090PUA webOS rooting

Working record and tooling for Drew's 50-inch 4K HDR LG 50UK6090PUA. The goals were to reduce advertising, improve responsiveness, and gain control over webOS. The TV reported firmware **05.50.70** before this work. The exact webOS version is still to be confirmed from the device.

The selected method is [throwaway96/faultmanager-autoroot](https://github.com/throwaway96/faultmanager-autoroot). Its author says it roots supported webOS 4.0+ TVs and installs Homebrew Channel. Drew checked [CanI.RootMy.TV for this model and firmware](https://cani.rootmy.tv/?q=50UK6090PUA%2005.50.70) and reported that faultmanager lists `05.50.70` as the latest known rootable firmware. Recheck the actual TV firmware before running anything; firmware updates can change compatibility.

## Current state

- LG developer account created. Developer Mode was enabled and paired with this NixOS laptop before rooting.
- Pairing succeeded. LG's CLI reported model `50UK6090PUA`, SDK `4.4.0`, and firmware `05.50.70`.
- The pinned faultmanager script reached `Rooting complete` and `Payload complete` on 2026-10-28. LG's Developer Mode app was uninstalled before restart. Homebrew Channel opened and loaded its catalog after restart; its Settings showed `Root status: OK`. See [`docs/sessions/2026-10-28.md`](docs/sessions/2026-10-28.md) for the session record.
- Root SSH is enabled with a dedicated key, and Telnet is disabled. The obsolete Developer Mode CLI profile was replaced with `lg-root`. No replacement launcher, debloating package, or performance-related service changes have been made. No performance improvement has been measured.

## Working environment on the laptop

```bash
cd lg-webos-rooting
direnv allow        # or: nix develop
just install        # install the pinned @webos-tools/cli dependency
just check          # show CLI version
just verify         # check the vendored script hash
```

The flake provides the command-line tools; `yarn install --frozen-lockfile --ignore-scripts` supplies LG's CLI from the lockfile. LG's [published CLI system requirements](https://webostv.developer.lge.com/develop/tools/cli-installation) list Ubuntu for Linux and recommend older Node releases. This NixOS setup is a local workflow, not an officially supported LG configuration.

## Rooted TV access and measurements

The TV is registered locally as webOS CLI device `lg-root` and SSH host `lg-webos`. The dedicated private key is `~/.ssh/lg_webos_root_50UK6090PUA`; its public key is installed on the TV in `/home/root/.ssh/authorized_keys`. The old Developer Mode profile, including its saved passphrase, was removed. Homebrew Channel's [rooted-device setup](https://github.com/webosbrew/webos-homebrew-channel/blob/main/README.md#configuring-webososeares-cli-with-rooted-tv) documents this key-based arrangement. After the second reboot, SSH key login worked, the known default root password was rejected, and Telnet port 23 remained closed.

To recreate the laptop configuration, use a dedicated key whose public half is already authorized on the TV. Put the following stanza in `~/.ssh/config.local` (included by this laptop's `~/.ssh/config`), replacing `TV_IP` and the key filename if needed:

```sshconfig
Host lg-webos
    HostName TV_IP
    User root
    IdentityFile ~/.ssh/lg_webos_root_50UK6090PUA
    IdentitiesOnly yes
    PasswordAuthentication no
```

Then register the CLI profile. The CLI's `privatekey` setting takes the **filename under `~/.ssh`**, not an absolute path:

```bash
yarn ares-setup-device -a lg-root -i username=root -i host=TV_IP -i port=22 -i privatekey=lg_webos_root_50UK6090PUA
```

```bash
just info       # model, SDK, firmware
just shell      # root shell through SSH
just snapshot   # read-only memory, storage, load, and processes
```

Performance work starts with repeated measurements under the same conditions: wait several minutes after boot, leave the TV on Home, time Home and app launches with the remote, and record a `just snapshot` result. Repeat each timing a few times before and after one change. The snapshot is diagnostic context, not a benchmark by itself. Do not remove system packages or disable services based on a single busy process; first identify what it does and prepare a way to reverse the change.

## Historical Developer Mode pairing

This records how the TV was paired **before rooting**. Developer Mode allowed sideloading without system-wide root; the initial handoff recorded a 1,000-hour session limit and possible removal of sideloaded apps when a session expired. Rooted Homebrew Channel avoids that renewal dependency.

On the unrooted TV, preparation was to disable automatic firmware updates and Quick Start+, install Developer Mode from the LG Content Store, sign in with an LG developer account, enable Dev Mode Status and allow its reboot, then enable Key Server while the TV and laptop were on the same network. The initial handoff located automatic updates under Settings → General → About This TV.

These commands then ran **on the laptop**. Follow [LG's connection instructions](https://webostv.developer.lge.com/develop/getting-started/developer-mode-app).

1. Run `yarn ares-setup-device` and choose **add**. Name the device `lg`, enter the TV's current IP address, port `9922`, SSH user `prisoner`, a blank password, and set it as the default device.
2. Run `yarn ares-novacom --device lg --getkey`. Enter the six-character, case-sensitive passphrase shown on the TV **at the local prompt**.
3. Run `yarn ares-device --device lg --system-info` and record the model, firmware, and SDK/webOS information in a session note.

For a direct SSH shell, use the private key path reported by `ares-novacom --getkey`:

```bash
ssh -i /path/reported/by/getkey -p 9922 prisoner@TV_IP
```

If current OpenSSH refuses the TV's older RSA algorithms, the [maintainer's SSH guide](https://gist.github.com/throwaway96/e811b0f7cc2a705a5a476a8dfa45e09f) suggests adding `-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedAlgorithms=+ssh-rsa` for this connection. Inspect the first host key prompt before accepting it. A `PTY allocation request failed` message may still leave a usable command shell.

## Rooting procedure used

Review the [current upstream README](https://github.com/throwaway96/faultmanager-autoroot) and the vendored `vendor/faultmanager-autoroot/autoroot.sh` before execution. The vendored script is from upstream commit `a972c95f4f4dbacdb72215409ea0c9eff39dabc1` (2026-03-01) and has SHA-256 `66a8a2816567a3c3d29768095873d347ec6bb2cbf60208979d15d7a42525d4d0`. The Homebrew Channel v0.7.3 IPK has SHA-256 `d10bf3c753551d7c72fb7a92b20fcd2317e502a220ac668ba8e76f6ea78b363c`. See `vendor/faultmanager-autoroot/PROVENANCE.md` for origins; the upstream license is in `COPYING` there.

Check the vendored script on the **laptop**:

```bash
sha256sum vendor/faultmanager-autoroot/autoroot.sh
```

On this TV, legacy `scp` is unavailable and SFTP did not complete. The successful transfer path was to download the exact pinned sources **on the TV** through LG's CLI from the laptop, then compare their hashes with the pinned hashes above:

```bash
yarn ares-novacom --device lg --run 'curl -fL -o /tmp/autoroot.sh -- https://raw.githubusercontent.com/throwaway96/faultmanager-autoroot/a972c95f4f4dbacdb72215409ea0c9eff39dabc1/autoroot.sh && sha256sum /tmp/autoroot.sh'
yarn ares-novacom --device lg --run 'curl -fL -o /tmp/hbchannel.ipk -- https://github.com/webosbrew/webos-homebrew-channel/releases/download/v0.7.3/org.webosbrew.hbchannel_0.7.3_all.ipk && sha256sum /tmp/hbchannel.ipk'
```

Proceed only if both TV hashes match the hashes above. Then run the script in the **TV's SSH shell**:

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

Root allows homebrew and system customization. [YouTube AdFree](https://github.com/webosbrew/youtube-webos) offers ad blocking and SponsorBlock within its YouTube app; it was not installed in this session. Changes to startup services or a replacement launcher need separate compatibility checks for this older TV. The [webOS Homebrew rooting overview](https://www.webosbrew.org/rooting/) describes what root adds relative to Developer Mode.

## Repository contents

- `flake.nix`, `flake.lock`, `.envrc`: Nix/direnv environment.
- `package.json`, `yarn.lock`: pinned LG webOS CLI.
- `justfile`: common laptop commands.
- `vendor/faultmanager-autoroot/`: reviewed script, checksum, provenance, and upstream license.
- [`docs/links.md`](docs/links.md): primary sources and future reference links.
- [`docs/session-template.md`](docs/session-template.md): record for each TV work session.

Record each device session's results in a separate note. The pinned script and license are kept here so future sessions use the reviewed revision.

## License

Project-authored documentation and tooling are [MIT licensed](LICENSE). The vendored faultmanager source retains its [AGPL-3.0-or-later license](vendor/faultmanager-autoroot/COPYING). The Homebrew Channel IPK is downloaded from upstream; it is not distributed in this repository.
