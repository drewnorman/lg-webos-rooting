# Home takeover and debloat review — 2026-10-28

## TV constraints

Read directly from the TV: LG 50UK6090PUA, firmware `05.50.70`, webOS TV Lite release `4.4.3`, SDK `4.4.0`, Node `0.12.2`, and Python `2.7.12`. Homebrew Channel root SSH works. At the time of this review, no Home takeover or debloat package was installed; GlassHouse was installed later that day for individual privacy controls. The TV registers `com.webos.app.mystarter` but does **not** register or have an application directory for `com.webos.app.home`. `mystarter` is not necessarily the Home launcher; its manifest calls it “My Starter.” This differs from the stock Home layout assumed by some webOS 4 takeover tools. Current idle snapshots show headroom, but do not measure Home responsiveness.

## Packages

| Option | Fit for this TV | Decision |
| --- | --- | --- |
| [GlassHouse](https://rorygallagher2024.github.io/glasshouse/) | Broad webOS 2.2–11 support, including 2018 C8/B8 reports. Provides ad and telemetry switches, per-app preloading controls, and service management. Its own replacement Home is **not** offered on webOS 4. [Home documentation](https://rorygallagher2024.github.io/glasshouse/dashboard/home/). | Best candidate for selective debloat/privacy. Start with settings and preloads; do not enable its experimental system-app hiding on webOS 4, which can restart the app manager and has caused black video. [Experimental feature notes](https://rorygallagher2024.github.io/glasshouse/experimental/). |
| [Lightkeeper](https://github.com/chiotas/lightkeeper) | A Home replacement that requires GlassHouse. Its maintainer reports a C8 running webOS `4.4.3` and firmware `05.50.70` working with Home key takeover and boot launch. It supplies its own small server and can be removed through its settings page or installer. | Strongest same-version evidence for Home takeover, but different hardware and not yet tried on this TV Lite model. Best candidate if GlassHouse is installed first. |
| [Hearth](https://github.com/rudra-avatar/Hearth) + [LG Input Hook](https://repo.webosbrew.org/apps/org.webosbrew.inputhook/) | Hearth is a normal web app built for old webOS browsers and has a webOS 4 user report. Input Hook can map Home directly to it. Hearth's fallback helper watches LG Home and may briefly show it before opening Hearth. | Plausible simpler launcher trial: install Hearth as an ordinary app first, then consider Home mapping. Less same-firmware evidence than Lightkeeper. [Takeover methods](https://github.com/rudra-avatar/Hearth#replacing-lg-home-rooted-tvs). |
| [Luma](https://github.com/ecklf/lg-luma) | Native launcher says it starts on webOS 4, but its built-in takeover method supports webOS 5, 6, 25 and 26; webOS 4 takeover failed on reported C8 and UM7450 models. Input Hook mapping is an alternative. | Possible standalone app experiment, not a direct built-in Home takeover choice for this TV. |
| [Homebar](https://github.com/rawinek/webos-homebar) | Its webOS 4 panel patches QML under `/usr/palm/applications/com.webos.app.home/qml/`, which this TV does not have. Its overlay variant requires Node 8 or newer, while this TV has Node 0.12. [Compatibility notes](https://github.com/rawinek/webos-homebar/blob/main/docs/compatibility.md). | No supported variant apparent here; a read-only `--probe` could confirm before any install. |
| [Launch Home](https://github.com/gprot42/webos-launch-home) | Maintainer reports webOS 4 support. Home takeover uses a watcher that reacts after stock Home appears; it has several optional background/voice features. | Lower priority for the stated responsiveness concern; no same-model evidence or direct takeover. |
| [lg-webos-ad-killer](https://github.com/nurikk/lg-webos-ad-killer) | Reversible ads/ACR/telemetry script with an `ads` profile and dry run. Tested on webOS 6/7 with Python 2.7/3, not on webOS 4 or TV Lite. | Consider only after inspecting its dry run and comparing with GlassHouse; avoid stacking two tools that change the same settings/services. |
| [webos-debloat gist](https://gist.github.com/D-Rekk/468e559e823106afea72689d1e2aa1f1) | Author tested one 2026 webOS 26 TV; this TV is much older. | Defer. |
| [CleanYourTV](https://github.com/lasharor/cleanyourtv-WebOS) | Explicitly requires webOS 5+; setup stops on webOS 4. | Exclude. |
| [own-your-glass](https://github.com/JulioFerrero/own-your-glass) | Supports webOS 10 by default; maintainer documents a prior webOS 4 failure that a factory reset did not fix. | Exclude. |

## Recommended path

1. Use GlassHouse for visibility and limited, reversible ad/privacy changes if the user wants debloat. Its [preload controls](https://rorygallagher2024.github.io/glasshouse/IMPLEMENTATION/#apps-kept-ready-in-the-background) have webOS 4 implementation notes. Review what is installed and currently used before disabling individual services or preloads. A lower resident workload might help, but no speed gain is established by the idle snapshots.
2. If a different Home is desired, try Lightkeeper with GlassHouse because the reported C8 has the same webOS release and firmware. Confirm the Home key, HDMI switching, Back behavior, and recovery on this TV before treating it as the default launcher.
3. Keep one Home takeover at a time. Preserve SSH access, a package-specific uninstall path, and the stock Home fallback before enabling any boot hook or button mapping.

This is a compatibility review made before [the GlassHouse privacy session](sessions/2026-10-28-glasshouse.md). No Home takeover has been installed.
