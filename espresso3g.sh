#!/bin/bash

# Thanks to Crave team and discord!

# Fail on error
set -e

# Init Rom Source
# repo init -b lineage-16.0

# Sync repositories
# /opt/crave/resync.sh

# Define repositories, branches, and directories in a single array
REPOSITORIES=(
    "https://github.com/MightyM17/android_device_samsung_espressowifi-1 lineage-16.0 device/samsung/espressowifi"
    "https://github.com/MightyM17/android_device_samsung_espresso3g-1 lineage-16.0 device/samsung/espresso3g"
    "https://github.com/MightyM17/android_kernel_ti_omap4 3.4/common kernel/ti/omap4"
    "https://github.com/MightyM17/android_hardware_ti_omap4 lineage-16.0 hardware/ti/omap4"
    "https://github.com/MightyM17/proprietary_vendor_samsung master vendor/samsung"
    "https://github.com/Unlegacy-Android/proprietary_vendor_ti stable vendor/ti"
)

# Function to update or clone a repository
function update_or_clone_repository() {
    local REPO_URL=$1
    local DIRECTORY=$2
    local BRANCH=$3

    if [ -d "$DIRECTORY" ]; then
        cd "$DIRECTORY" || exit
        git fetch --quiet
        git reset --hard "origin/$BRANCH"
        cd - || exit
    else
        git clone "$REPO_URL" "$DIRECTORY" --branch "$BRANCH" --depth=1
    fi
}

# Clone or update each repository
for REPO in "${REPOSITORIES[@]}"; do
    IFS=' ' read -r -a REPO_ARRAY <<< "$REPO"
    REPO_URL="${REPO_ARRAY[0]}"
    DIRECTORY="${REPO_ARRAY[-1]}"
    BRANCH="${REPO_ARRAY[-2]}"
    echo "Updating or cloning $DIRECTORY..."
    update_or_clone_repository "$REPO_URL" "$DIRECTORY" "$BRANCH"
done

echo "Update or clone complete."

# Patches for av - Video decoding
cd frameworks/av
git reset --hard
curl -L https://github.com/MightyM17/android_frameworks_av/commit/2df86cce763e0e5135fcdef3ed34fcf5f4c3efa8.patch | git apply -v

cd ../..

# Patches for earlysleep
cd system/core
git reset --hard
curl -L https://github.com/MightyM17/android_system_core/commit/4a5e8f9a9985ff542af0dfd42805cd954e3ed2fc.patch | git apply -v
curl -L https://github.com/MightyM17/android_system_core/commit/74c81d1e2cd4e2757d88301acc4f42d37e2f98ae.patch | git apply -v

cd ../..

# Source environment setup script
source build/envsetup.sh

croot

# Set up build configuration
lunch lineage_espresso3g-userdebug

# Start the build process
mka bacon
