#!/bin/bash

## Made by L50N with <3

if [[ $EUID -ne 0 ]]; then
    echo "Permission Denied: Please run as the Galactic Root Commander."
    exit 1
fi

check_galactic_position() {
    if ! command -v apt > /dev/null; then
        echo "Interstellar mismatch: Your spaceship does not seem to be Debian-based."
        echo "The Moon Central Command requires 'apt' to proceed with the mission."
        exit 1
    fi
}

## Check for Debian based system
check_galactic_position

display_ascii_art() {
    cat << "EOF"
    Launching Nextcloud Installation Sequence 🚀

                |
               / \
              / _ \
             |     |
             |'._.'|
             |     |
           ,'|  |  |'.
          /  |  |  |  \
          |,-'--|--'-,|

EOF
}

display_menu() {
    echo -e "\nNextcloud Command Module at your service, Captain:"
    echo "[1] Install Nextcloud"
    echo "[2] Start Containers"
    echo "[3] Stop Containers"
    echo "[4] Remove Everything (including Docker & Docker Compose)"
    echo "[5] Update Nextcloud"
    echo "[6] Exit Control Panel"
    echo
    read -rp "captain@bridge:~$ " choice
}

install_nextcloud() {
    echo "[Phase 1] Preparing for lift-off: Deploying Nextcloud into the Cosmos"

    if ! command -v curl &>/dev/null; then
        echo "Installing CURL for interstellar communication... 📡"
        apt-get update && apt-get install -y curl
    fi

    echo "Installing the Docker Engine, the heart of our spaceship... 🚀"
    if ! command -v docker &>/dev/null; then
        curl -fsSL https://get.docker.com | sh
    fi

    echo "Installing Docker Compose to navigate the stars... 🌌"
    if ! command -v docker-compose &>/dev/null; then
        COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
        curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
    fi
    
    if [ -f "./docker-compose.yml" ]; then
        docker-compose up -d
        echo "Nextcloud is now floating in the digital ether at localhost!"
    else
        echo "Abort! Abort! The docker-compose.yml is missing from the launchpad."
        exit 1
    fi
}

start_containers() {
    echo "[Phase 2] Warp drives engaging... 🌟"
    docker-compose up -d
    echo "Containers have jumped to hyperspace!"
}

stop_containers() {
    echo "[Phase 3] All personnel to cryosleep chambers..."
    docker-compose down
    echo "Containers are now in hibernation mode."
}

remove_nextcloud() {
    echo "[Phase 5] Initiating self-destruct sequence..."
    docker-compose down -v
    echo "Purging all traces of Docker and its crew..."
    apt-get purge docker.io docker-compose docker-ce docker-ce-cli docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin containerd.io -y
    apt-get autoremove -y
    echo "The ship is now a ghost, lost in the cosmos."
}

update_nextcloud() {
    echo "[Phase 6] Updating galactic charts and Nextcloud systems..."
    docker-compose down
    docker-compose pull
    docker-compose up -d
    echo "The update is complete. Nextcloud is now at the latest stellar revision!"
}

while true; do
    clear
    display_ascii_art
    display_menu

    case $choice in
        1) install_nextcloud;;
        2) start_containers;;
        3) stop_containers;;
        4) remove_nextcloud;;
        5) update_nextcloud;;
        6) echo "Docking complete. Enjoy your time on the spaceport!"; exit 0;;
        *) echo "Unidentified command! Is that an alien language? 🛸";;
    esac
    echo "Press any key to warp back to the Command Module..."
    read -r -n 1
done
