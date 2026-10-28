# faultmanager-autoroot source

- Upstream: https://github.com/throwaway96/faultmanager-autoroot
- Revision: `a972c95f4f4dbacdb72215409ea0c9eff39dabc1` (2026-03-01)
- `autoroot.sh` SHA-256: `66a8a2816567a3c3d29768095873d347ec6bb2cbf60208979d15d7a42525d4d0`
- License: AGPL-3.0-or-later; see `COPYING`.

`autoroot.sh`, `README.upstream.md`, and `COPYING` were copied without
modification from that revision. Review the script and its upstream changes
before using it with another TV or firmware.

The Homebrew Channel v0.7.3 IPK is not stored in this repository. Download the
[upstream release asset](https://github.com/webosbrew/webos-homebrew-channel/releases/download/v0.7.3/org.webosbrew.hbchannel_0.7.3_all.ipk)
and verify its SHA-256:
`d10bf3c753551d7c72fb7a92b20fcd2317e502a220ac668ba8e76f6ea78b363c`.
Homebrew Channel is [MIT licensed](https://github.com/webosbrew/webos-homebrew-channel/blob/main/LICENSE).
When the verified IPK is beside `autoroot.sh` on the TV, the script uses it
instead of downloading the asset at runtime.
