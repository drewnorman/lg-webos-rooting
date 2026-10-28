default:
    @just --list

# Install the exact webOS CLI release from yarn.lock.
install:
    yarn install --frozen-lockfile --ignore-scripts

# Show the webOS CLI version and active profile.
check:
    yarn ares -V
    yarn ares-config --profile-details

# Verify the vendored root script against its pinned hash.
verify:
    sha256sum -c vendor/faultmanager-autoroot/SHA256SUMS

# Show configured webOS CLI devices.
devices:
    yarn ares-setup-device --list

# Confirm that the rooted TV responds.
info:
    yarn ares-device --device lg-root --system-info

# Open a root shell through the dedicated key in ~/.ssh.
shell:
    ssh lg-webos

# Read-only snapshot. Compare under the same idle or app workload.
snapshot:
    ssh -o BatchMode=yes lg-webos 'uptime; grep -E "^(MemTotal|MemAvailable|SwapTotal|SwapFree):" /proc/meminfo; df -h /var /media/developer /tmp; top -b -n 1 | head -20'
