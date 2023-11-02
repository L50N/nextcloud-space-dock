#!/bin/bash

# Stellar Nextcloud Speed Installer

# Engage thrusters if we have root clearance
if [ "$EUID" -ne 0 ]; then
    echo "Permission Denied: Please run as the root overlord."
    exit
fi

# A beautiful ASCII spaceship
display_ascii_art() {
    echo "Launching Nextcloud Installation Sequence 🚀"
echo
echo "            |"
echo "           / \ "
echo "          / _ \ "
echo "         |     |"
echo "         |'._.'|"
echo "         |     |"
echo "       ,'|  |  |'."
echo "      /  |  |  |  \ "
echo "      |,-'--|--'-.|"
echo
}

# Command Module (Main Menu)
display_menu() {
    echo -e "\nCommand Module:"
    echo "1. Install Nextcloud"
    echo "2. Start Containers"
    echo "3. Stop Containers"
    echo "4. Restart Containers"
    echo "5. Remove Everything (including Docker & Docker Compose)"
    echo "6. Update Nextcloud"
    echo "7. Exit Control Panel"
    echo -e "\nMake your selection and press [ENTER]: "
    read -r choice
}

# Installation Protocol
install_nextcloud() {
    echo "[Phase 1] Deploying Nextcloud into the Cosmos"

    # Install CURL, if not present on the system
    echo "Installing CURL for communication with remote space stations..."
    apt-get install curl -y

    # Install Docker & Docker Compose
    echo "Installing Docker Engine... 🐳"
    curl -fsSL https://get.docker.com | sh
    
    echo "Installing the latest version of Docker Compose... 🌌"
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Launch Nextcloud
    docker-compose up -d
    echo "Nextcloud is now orbiting at localhost!"
}

# Update the ship's systems
start_containers() {
    echo "[Phase 2] Starting the Ship's Systems"
    
    # Launch the ship
    docker-compose up -d
    echo "Starting completed. Nextcloud now is ready to control!"
}

# Halt all systems
stop_containers() {
    echo "[Phase 3] Initiating System Shutdown"
    docker-compose down
    echo "Containers are now in stasis mode."
}

# Reboot the habitat modules
restart_containers() {
    echo "[Phase 4] Rebooting Space Habitat Modules"
    docker-compose down
    docker-compose up -d
    echo "Containers are now awakening from stasis mode."
}

# De-orbit the entire station
remove_nextcloud() {
    echo "[Phase 5] De-orbiting Nextcloud and Engaging Cleanup Crew"
    
    # Remove all Docker Containers and Images
    docker-compose down -v
    
    # Expel Docker & Docker Compose from the airlock
    apt-get purge docker.io docker-compose -y
    apt-get autoremove -y
    echo "The ship has been scrubbed clean!"
}

# Update the ship's systems
update_nextcloud() {
    echo "[Phase 6] Updating the Ship's Systems"
    
    # Ensure no passengers are aboard during update
    docker-compose down
    
    # Update the ship's blueprints
    docker-compose pull
    
    # Relaunch the ship
    docker-compose up -d
    echo "Update complete. Nextcloud is now equipped with the latest tech!"
}


# Infinite loop to keep the script running
while true; do
    clear
    display_ascii_art
    display_menu
    
    case "$choice" in
        1) install_nextcloud;;
        2) start_containers;;
        3) stop_containers;;
        4) restart_containers;;
        5) remove_nextcloud;;
        6) update_nextcloud;;
        7) echo "Safe travels, Astronaut!"; exit 0;;
        *) echo "Uh oh! That's an alien command 🛸";;
    esac
    echo "Press any key to navigate back to the Command Module..."
    read -r -n 1
done
