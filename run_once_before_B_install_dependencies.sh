#!/bin/sh

# First script to be run after "chezmoi init --apply"
# Installs pre-opporational packages.


# Function to check if reflector is installed
check_reflector() {
    if ! command -v reflector &> /dev/null; then
        sudo pacman -S reflector
        echo "reflector installed"
    else
        echo "reflector is already installed"
    fi
}

# Function to copy files if reflector is installed
copy_files() {
    if [[ -f /etc/systemd/system/reflector.service ]] && [[ -f /etc/systemd/system/reflector.timer ]]; then
        echo "Reflector service and timer files already exist"
    else
        sudo cp /home/dameon/.local/share/chezmoi/Development/Arch-configuration/resources/files/reflector.service /etc/systemd/system/
        sudo cp /home/dameon/.local/share/chezmoi/Development/Arch-configuration/resources/files/reflector.timer /etc/systemd/system/
        echo "Reflector service and timer files copied successfully"
    fi
}

# Function to start reflector service and timer
start_reflector() {
    sudo systemctl start reflector.service
    sudo systemctl start reflector.timer
    echo "Mirrorlist updated and timer set for weekly"
}

# Main script
check_reflector
copy_files

if ! systemctl is-active --quiet reflector.timer; then
    echo "reflector.timer is not running. Starting it..."
    start_reflector
else
    echo "reflector.timer is already running."
fi



if ! [[ $(command -v age) ]];
then
    echo "Installing package 'age' encryption tool..."

    sudo pacman -S age

    echo "age package installed"
fi

if ! [[ $(command -v ansible) ]];
then
    sudo pacman -S ansible

    echo "Ansible Installed"
fi

# Check if the community.general collection is installed
ansible-galaxy collection list | grep -q 'community.general'

# Check the exit status of the grep command
if [ $? -ne 0 ]; then
    # Install the collection if it is not found
    ansible-galaxy collection install community.general --force
    echo "Ansible community.general installed."
else
    echo "Ansible community.general is already installed."
fi