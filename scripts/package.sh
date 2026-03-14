#!/bin/bash

set -euo pipefail

# Set-up our environment
bash -x $(dirname $0)/env.sh
source $(dirname $0)/env.sh

# Package ATN-XPIHandler
export ATNXPI_FROM_PACKAGE=1
if [ "${ATNXPI_LOG_PACKAGE}" == 1 ]; then
    PACKAGE_LOG_FILE="${ATNXPI_LOG_DIR}/package.log"

    # If the log file already exists, remove it
    if [ -f "${PACKAGE_LOG_FILE}" ]; then
        rm "${PACKAGE_LOG_FILE}"
    fi

    # Ensure our log directory exists
    mkdir -vp "${ATNXPI_LOG_DIR}"

    bash -x "${ATNXPI_SCRIPTS}/package-atnxpi.sh" > >(tee -a "${PACKAGE_LOG_FILE}") 2>&1
else
    bash -x "${ATNXPI_SCRIPTS}/package-atnxpi.sh"
fi
