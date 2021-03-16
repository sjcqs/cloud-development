#!/bin/bash
ANDROID_STUDIO_PATH="https://redirector.gvt1.com/edgedl/android/studio/ide-zips/2020.3.1.9/android-studio-2020.3.1.9-linux.tar.gz"

# helper functions
info() {
    echo '[INFO] ' "$@"
}
warn() {
    echo '[WARN] ' "$@" >&2
}
fatal() {
    echo '[ERROR] ' "$@" >&2
    exit 1
}

is_projector_installed() {
    command -v projector
}

install_android_studio() {
    info "Installing Android Studio"
    cd ~
    curl -L --output /tmp/android-studio.tar.gz "$ANDROID_STUDIO_PATH"
    tar -xvf /tmp/android-studio.tar.gz
}

install_projector() {
    cd ~
    $SUDO apt install python3 python3-pip python3-setuptools -y
    $SUDO apt install libxext6 libxrender1 libxtst6 libfreetype6 libxi6 -y
    $SUDO apt install git -y
    pip3 install projector-installer --user
    echo "export PATH=${PATH}:~/.local/bin" >> ~/.profile
    source ~/.profile
}

setup_env() {
    SUDO=sudo
    if [ $(id -u) -eq 0 ]; then
        SUDO=
    fi
    source ~/.profile
}

# the install process
{
    setup_env
    if [[ -x $(is_projector_installed) ]]; then
        info "Installed"
        # TODO check for updates
    else
        warn "Not installed"
        info "Installing projector"
        install_projector
        install_android_studio
    fi
    info "Finished"
} >> ~/logs 2>&1
