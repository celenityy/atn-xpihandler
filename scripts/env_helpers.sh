
# Set platform
if [[ "${OSTYPE}" == "darwin"* ]]; then
    readonly ATNXPI_PLATFORM='darwin'
else
    readonly ATNXPI_PLATFORM='linux'
fi
export ATNXPI_PLATFORM

# Set OS
if [[ "${ATNXPI_PLATFORM}" == 'darwin' ]]; then
    readonly ATNXPI_OS='osx'
elif [[ "${ATNXPI_PLATFORM}" == 'linux' ]]; then
    if [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        if [[ -n "${ID}" ]]; then
            readonly ATNXPI_OS="${ID}"
        else
            readonly ATNXPI_OS='unknown'
        fi
    else
        readonly ATNXPI_OS='unknown'
    fi
else
    readonly ATNXPI_OS='unknown'
fi
export ATNXPI_OS
