# References

Checked 2026-10-28. Review the current upstream instructions before another rooting attempt.

| Source | Use |
| --- | --- |
| [LG 50UK6090PUA specifications](https://www.lg.com/us/tvs/lg-50UK6090PUA-4k-uhd-tv) | Model identification; 50-inch 4K HDR TV. |
| [LG support page](https://www.lg.com/us/support/product/lg-50UK6090PUA) | Official model and firmware support information. |
| [CanI.RootMy.TV model/firmware query](https://cani.rootmy.tv/?q=50UK6090PUA%2005.50.70) | Recheck exploit compatibility against the TV's actual firmware. |
| [LG Developer Mode app guide](https://webostv.developer.lge.com/develop/getting-started/developer-mode-app) | TV setup, pairing fields, passphrase, and system-info test. |
| [LG webOS CLI installation](https://webostv.developer.lge.com/develop/tools/cli-installation) | CLI package and official system requirements. |
| [LG CLI developer guide](https://webostv.developer.lge.com/develop/tools/cli-dev-guide) | `ares-*` command syntax. |
| [Community Developer Mode guide](https://www.webosbrew.org/devmode/) | Background on Developer Mode sessions and pairing. |
| [faultmanager-autoroot README](https://github.com/throwaway96/faultmanager-autoroot) | Authoritative procedure, options, warnings, and troubleshooting. |
| [faultmanager-autoroot script](https://github.com/throwaway96/faultmanager-autoroot/blob/main/autoroot.sh) | Review the exact code before execution and record its revision/hash. |
| [DejaVuln autoroot](https://github.com/throwaway96/dejavuln-autoroot) | Alternative method noted in the pre-root compatibility review; not used. |
| [Maintainer's Developer Mode SSH notes](https://gist.github.com/throwaway96/e811b0f7cc2a705a5a476a8dfa45e09f) | Direct SSH invocation and legacy RSA negotiation if needed. |
| [webOS Homebrew rooting overview](https://www.webosbrew.org/rooting/) | Root versus Developer Mode capabilities. |
| [Homebrew Channel](https://github.com/webosbrew/webos-homebrew-channel) | Installed by the autoroot script. |
| [YouTube Ad-Free homebrew app](https://github.com/webosbrew/youtube-webos) | Possible post-root choice; compatibility and behavior to verify separately. |

The upstream project's README gives a more current patch-status warning than the webOS Homebrew overview's older faultmanager summary; use the upstream project and CanI.RootMy.TV for compatibility decisions.
