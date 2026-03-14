#!/bin/bash

set -euo pipefail

# Set-up our environment
bash -x $(dirname $0)/env.sh
source $(dirname $0)/env.sh

if [[ -z "${ATNXPI_FROM_PACKAGE+x}" ]]; then
    echo_red_text 'ERROR: Do not call package-atnxpi.sh directly. Instead, use package.sh.' >&1
    exit 1
fi

# Include version info
source "${ATNXPI_VERSIONS}"

if [[ -z "${ATNXPI_ADDON_ID}" ]]; then
    echo "\${ATNXPI_ADDON_ID} is not set! Aborting..."
    exit 1
fi

if [[ -z "${ATNXPI_VERSION}" ]]; then
    echo "\${ATNXPI_VERSION} is not set! Aborting..."
    exit 1
fi

echo_green_text "Preparing to package ATN-XPIHandler ${ATNXPI_VERSION}"

# Create build directories
mkdir -p "${ATNXPI_BUILD}"
mkdir -p "${ATNXPI_OUTPUTS}"

cp -f "${ATNXPI_BUILD_RESOURCES}/manifest.json" "${ATNXPI_ROOT}/extension/manifest.json"

# Set add-on ID
"${ATNXPI_SED}" -i -e "s|{ATNXPI_ADDON_ID}|${ATNXPI_ADDON_ID}|g" "${ATNXPI_ROOT}/extension/manifest.json"

# Set version
"${ATNXPI_SED}" -i -e "s|{ATNXPI_VERSION}|${ATNXPI_VERSION}|g" "${ATNXPI_ROOT}/extension/manifest.json"

if [[ "${ATNXPI_OS}" == 'osx' ]]; then
    /usr/sbin/dot_clean -mv "${ATNXPI_ROOT}/extension"
fi

pushd "${ATNXPI_ROOT}/extension"
zip -r -FS "${ATNXPI_OUTPUTS}/ATN-XPIHandler-${ATNXPI_VERSION}-unsigned.xpi" *
popd

echo_green_text "SUCCESS: Packaged ATN-XPIHandler ${ATNXPI_VERSION}"
