
# Set platform
if [[ "${OSTYPE}" == "darwin"* ]]; then
    export ATNXPI_PLATFORM='darwin'
else
    export ATNXPI_PLATFORM='linux'
fi

# Set OS
if [[ "${ATNXPI_PLATFORM}" == 'darwin' ]]; then
    export ATNXPI_OS='osx'
elif [[ "${ATNXPI_PLATFORM}" == 'linux' ]]; then
    if [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        if [[ -n "${ID}" ]]; then
            export ATNXPI_OS="${ID}"
        else
            export ATNXPI_OS='unknown'
        fi
    else
        export ATNXPI_OS='unknown'
    fi
else
    export ATNXPI_OS='unknown'
fi
