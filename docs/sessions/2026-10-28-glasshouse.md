# GlassHouse privacy session — 2026-10-28

## Install

- TV: LG 50UK6090PUA, firmware `05.50.70`, webOS TV Lite `4.4.3`, SDK `4.4.0`.
- Installed [GlassHouse v0.128.1](https://github.com/rorygallagher2024/glasshouse/releases/tag/v0.128.1) from pinned source commit `79ebb6902dc1dfcb4b3cd542ccd8806253964702` over the existing root SSH connection. The installer created `/var/lib/tvweb`, installed its boot hook `50-tvweb`, started the server and watchdog, and added its dashboard TV app to the stock Home screen.
- Seeded the server with `host: 127.0.0.1` and MQTT disabled. Verified that port 8080 listens only on `127.0.0.1`. The TV app can use it locally. For a laptop browser, use an SSH tunnel such as `ssh -F ~/.ssh/config -N -L 127.0.0.1:18080:127.0.0.1:8080 lg-webos`, then open `http://127.0.0.1:18080/?tab=privacy`.
- Root SSH key remained present and Telnet's disable flag remained set. No Home takeover was enabled.

## Individual privacy controls

GlassHouse's read-only privacy report showed Live Plus already off and Limit ad tracking already on. The following were on and were switched off individually through GlassHouse's local API; each write returned success, and a fresh readback showed the requested state:

| Control | Before | After |
| --- | --- | --- |
| Screen recognition master consent (`acrOnAllowed`) | On | Off |
| Ads based on what you watch (`acrAdAllowed`) | On | Off |
| Personalised advertising (`customAdAllowed`) | On | Off |
| Sharing data with other companies (`thirdPartySharingAllowed`) | On | Off |
| Additional usage data (`additionalDataAllowed`) | On | Off |
| Sponsored tiles on Home (`homePromotion`) | On | Off |

Afterwards, GlassHouse reported ACR not actively recognizing or capturing. The ad and telemetry host blocker remains off, and the diagnostics collector/uploader remain running. Unknown consent flags, terms, network access, voice settings, and installed apps were not changed. These LG settings persist independently of the GlassHouse server; uninstalling it will not reset them automatically. The pre-change GlassHouse privacy response is saved temporarily at `/tmp/lg-glasshouse-privacy-before.json` for this session.

## Status and follow-up

- GlassHouse server and watchdog reported running. A process snapshot showed roughly 35 MB resident for the server and under 1 MB for the watchdog. A two-minute-after-boot snapshot showed 243 MB available RAM and 69% CPU idle; it is not comparable to the prior settled Home measurement and does not establish any performance effect.
- Lightkeeper is deferred. No other launcher or debloat package was installed. GlassHouse registration and its running server were verified, but no reboot was performed to test boot-hook persistence.
- GlassHouse's [uninstall instructions](https://rorygallagher2024.github.io/glasshouse/managing/#uninstalling) describe how to remove its server and boot hook. The six LG privacy settings above must be changed back individually if desired.
