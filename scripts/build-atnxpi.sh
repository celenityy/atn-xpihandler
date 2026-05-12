#!/bin/bash

set -euo pipefail

# Set-up our environment
source $(dirname $0)/env.sh

# Include utilities
source "${ATNXPI_UTILS}"

if [[ -z "${ATNXPI_FROM_BUILD+x}" ]]; then
    echo_red_text 'ERROR: Do not call build-atnxpi.sh directly. Instead, use build.sh.' >&1
    exit 1
fi

readonly target="$1"

# Set-up target parameters
ATNXPI_BUILD_ATN=0
ATNXPI_BUILD_DIRECT=0

if [ "${target}" == 'atn' ]; then
    # Build ATN-XPIHandler (ATN)
    ATNXPI_BUILD_ATN=1
elif [ "${target}" == 'direct' ]; then
    # Build ATN-XPIHandler (Self-distribution)
    ATNXPI_BUILD_DIRECT=1
elif [ "${target}" == 'all' ]; then
    # If no argument is specified (or argument is set to "all"), just build both
    ATNXPI_BUILD_ATN=1
    ATNXPI_BUILD_DIRECT=1
else
    echo_red_text "ERROR: Invalid target: ${target}\n You must enter one of the following:"
    echo 'All:                                  all (Default)'
    echo 'ATN-XPIHandler (ATN):                 atn'
    echo 'ATN-XPIHandler (Self-distribution):   direct'
    exit 1
fi
readonly ATNXPI_BUILD_ATN
readonly ATNXPI_BUILD_DIRECT

# Include version info
source "${ATNXPI_VERSIONS}"

if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
    if [[ -z "${ATNXPI_ATN_ADDON_ID}" ]]; then
        echo "\${ATNXPI_ATN_ADDON_ID} is not set! Aborting..."
        exit 1
    fi
fi

if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
    if [[ -z "${ATNXPI_ADDON_ID}" ]]; then
        echo "\${ATNXPI_ADDON_ID} is not set! Aborting..."
        exit 1
    fi
fi

if [[ -z "${ATNXPI_VERSION}" ]]; then
    echo "\${ATNXPI_VERSION} is not set! Aborting..."
    exit 1
fi

echo_green_text "Preparing to build ATN-XPIHandler ${ATNXPI_VERSION}"

# Create build directories
mkdir -p "${ATNXPI_BUILD}"
if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
    mkdir -p "${ATNXPI_OUTPUTS}/atn"
fi
if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
    mkdir -p "${ATNXPI_OUTPUTS}/direct"
fi

function set_version() {
    # Set version
    if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
        "${ATNXPI_SED}" -i -e "s|{ATNXPI_VERSION}|${ATNXPI_VERSION}|g" "${ATNXPI_OUTPUTS}/atn/manifest.json"
    fi
    if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
        "${ATNXPI_SED}" -i -e "s|{ATNXPI_VERSION}|${ATNXPI_VERSION}|g" "${ATNXPI_OUTPUTS}/direct/manifest.json"
    fi
}

function prep_atnxpi() {
    # ATN-XPIHandler
    echo_red_text 'Preparing your build environment...'

    if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
        if [[ -f "${ATNXPI_OUTPUTS}/atn/background.js" ]]; then
            rm "${ATNXPI_OUTPUTS}/atn/background.js"
        fi
        cp -f "${ATNXPI_ROOT}/extension/background.js" "${ATNXPI_OUTPUTS}/atn/background.js"

        if [[ -f "${ATNXPI_OUTPUTS}/atn/manifest.json" ]]; then
            rm "${ATNXPI_OUTPUTS}/atn/manifest.json"
        fi
        cp -f "${ATNXPI_TEMPLATES}/manifest-atn.json" "${ATNXPI_OUTPUTS}/atn/manifest.json"
    fi

    if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
        if [[ -f "${ATNXPI_OUTPUTS}/direct/background.js" ]]; then
            rm "${ATNXPI_OUTPUTS}/direct/background.js"
        fi
        cp -f "${ATNXPI_ROOT}/extension/background.js" "${ATNXPI_OUTPUTS}/direct/background.js"

        if [[ -f "${ATNXPI_OUTPUTS}/direct/manifest.json" ]]; then
            rm "${ATNXPI_OUTPUTS}/direct/manifest.json"
        fi
        cp -f "${ATNXPI_TEMPLATES}/manifest.json" "${ATNXPI_OUTPUTS}/direct/manifest.json"

        # Set update URL
        "${ATNXPI_SED}" -i -e "s|{ATNXPI_UPDATE_URL}|${ATNXPI_UPDATE_URL}|g" "${ATNXPI_OUTPUTS}/direct/manifest.json"
    fi

    # Set add-on ID
    if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
        "${ATNXPI_SED}" -i -e "s|{ATNXPI_ADDON_ID}|${ATNXPI_ATN_ADDON_ID}|g" "${ATNXPI_OUTPUTS}/atn/manifest.json"
    fi
    if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
        "${ATNXPI_SED}" -i -e "s|{ATNXPI_ADDON_ID}|${ATNXPI_ADDON_ID}|g" "${ATNXPI_OUTPUTS}/direct/manifest.json"
    fi

    echo_green_text 'SUCCESS: Prepared build environment'
}

function build_atnxpi() {
    # Begin the build...
    echo_red_text "Building ATN-XPIHandler ${ATNXPI_VERSION}..."

    if [[ "${ATNXPI_OS}" == 'osx' ]]; then
        if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
            /usr/sbin/dot_clean -mv "${ATNXPI_OUTPUTS}/atn"
        fi
        if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
            /usr/sbin/dot_clean -mv "${ATNXPI_OUTPUTS}/direct"
        fi
    fi

    if [ "${ATNXPI_BUILD_ATN}" == 1 ]; then
        pushd "${ATNXPI_OUTPUTS}/atn"
        zip -r -FS "${ATNXPI_OUTPUTS}/atn-xpihandler-${ATNXPI_VERSION}-atn-unsigned.xpi" *
        popd
    fi
    if [ "${ATNXPI_BUILD_DIRECT}" == 1 ]; then
        pushd "${ATNXPI_OUTPUTS}/direct"
        zip -r -FS "${ATNXPI_OUTPUTS}/atn-xpihandler-${ATNXPI_VERSION}-unsigned.xpi" *
        popd
    fi

    echo_green_text "SUCCESS: Built ATN-XPIHandler ${ATNXPI_VERSION}"
}

prep_atnxpi
set_version
build_atnxpi
