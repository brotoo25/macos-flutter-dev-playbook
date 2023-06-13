#!/bin/bash

# Path to shell configuration file
if [[ $SHELL == *"zsh"* ]]; then
    SHELL_CONFIG_FILE="${HOME}/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    SHELL_CONFIG_FILE="${HOME}/.bashrc"
else
    echo "Unsupported shell. Please use Bash or Zsh."
    exit 1
fi

# Detect machine architecture
ARCHITECTURE="$(uname -m)"

if [ "${ARCHITECTURE}" = "arm64" ]; then
    # M1 chip
    PYTHON_PATH="/opt/homebrew/bin/python3"
    PIP_PATH="/opt/homebrew/bin/pip3"
    ANSIBLE_PATH="/opt/homebrew/bin/ansible"
    BREW_PATH="/opt/homebrew/bin"
else
    # Intel chip
    PYTHON_PATH="/usr/local/bin/python3"
    PIP_PATH="/usr/local/bin/pip3"
    ANSIBLE_PATH="/usr/local/bin/ansible"
    BREW_PATH="/usr/local/bin"
fi

# Python Version
PYTHON_VERSION="3.9.5"

# Function to check if command exists
function command_exists() {
    type "$1" &>/dev/null
}

# Check for Python3, install if we don't have it
if ! command_exists $PYTHON_PATH; then
    echo "Installing Python $PYTHON_VERSION..."
    curl
    "https://www.python.org/ftp/python/$PYTHON_VERSION/python-$PYTHON_VERSION-macosx10.9.pkg"
    -o "python-$PYTHON_VERSION.pkg"
    sudo installer -pkg python-$PYTHON_VERSION.pkg -target /
    rm python-$PYTHON_VERSION.pkg
    echo "export PATH=\"\$PATH:${HOME}/Library/Python/${PYTHON_VERSION}/bin\"" >>"${SHELL_CONFIG_FILE}"

    echo "Python $PYTHON_VERSION installation complete!"
else
    echo "Python3 is already installed!"
fi

# Check for pip3, install if we don't have it
if ! command_exists $PIP_PATH; then
    echo "pip3 not found! Installing..."
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
    python3 get-pip.py
    rm get-pip.py

    echo "pip3 installation complete!"
else
    echo "pip3 is already installed!"
fi

# Check for Ansible, install if we don't have it
if ! command_exists $ANSIBLE_PATH; then
    echo "Installing Ansible..."
    pip3 install ansible
    echo "export PATH=\"\$PATH:${BREW_PATH}\"" >>"${SHELL_CONFIG_FILE}"

    echo "Ansible setup complete!"
else
    echo "Ansible is already installed!"
fi