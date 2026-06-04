#!/bin/bash

set -euo pipefail

# Set-up our environment
if [[ -z "${ATNXPI_SET_ENVS+x}" ]]; then
    bash -x $(dirname $0)/env.sh
fi
source $(dirname $0)/env.sh

# Set up target parameters
if [[ -z "${1+x}" ]]; then
    readonly target='all'
else
    readonly target=$(echo "${1}" | "${ATNXPI_AWK}" '{print tolower($0)}')
fi

# Build ATN-XPIHandler
readonly ATNXPI_FROM_BUILD=1
export ATNXPI_FROM_BUILD
if [[ "${ATNXPI_LOG_BUILD}" == 1 ]]; then
    readonly BUILD_LOG_FILE="${ATNXPI_LOG_DIR}/build.log"

    # If the log file already exists, remove it
    if [[ -f "${BUILD_LOG_FILE}" ]]; then
        rm "${BUILD_LOG_FILE}"
    fi

    # Ensure our log directory exists
    mkdir -vp "${ATNXPI_LOG_DIR}"

    bash -x "${ATNXPI_SCRIPTS}/build-atnxpi.sh" "${target}" > >(tee -a "${BUILD_LOG_FILE}") 2>&1
else
    bash -x "${ATNXPI_SCRIPTS}/build-atnxpi.sh" "${target}"
fi
