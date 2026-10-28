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

# Register the TV interactively. Use SSH port 9922 and user prisoner.
register:
    yarn ares-setup-device

# Retrieve the Developer Mode SSH key. Enter the on-screen passphrase locally.
key:
    yarn ares-novacom --device lg --getkey

# Confirm that the registered TV responds.
info:
    yarn ares-device --device lg --system-info
