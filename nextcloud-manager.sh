#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit
fi

LOG_FILE="/tmp/nextcloud-speed-installer.log"
exec &>> "$LOG_FILE"

display_ascii_art() {
    echo "╭━╮╱╭┳━━━┳━╮╭━┳━━━━┳━━━┳╮╱╱╭━━━┳╮╱╭┳━━━╮"
    echo "┃┃╰╮┃┃╭━━┻╮╰╯╭┫╭╮╭╮┃╭━╮┃┃╱╱┃╭━╮┃┃╱┃┣╮╭╮┃"
    echo "┃╭╮╰╯┃╰━━╮╰╮╭╯╰╯┃┃╰┫┃╱╰┫┃╱╱┃┃╱┃┃┃╱┃┃┃┃┃┃"
    echo "┃┃╰╮┃┃╭━━╯╭╯╰╮╱╱┃┃╱┃┃╱╭┫┃╱╭┫┃╱┃┃┃╱┃┃┃┃┃┃"
    echo "┃┃╱┃┃┃╰━━┳╯╭╮╰╮╱┃┃╱┃╰━╯┃╰━╯┃╰━╯┃╰━╯┣╯╰╯┃"
    echo "╰╯╱╰━┻━━━┻━╯╰━╯╱╰╯╱╰━━━┻━━━┻━━━┻━━━┻━━━╯"
}

display_menu() {
    echo -e "\nMain Menu:"
    echo "1. Install"
    echo "2. Stop Containers"
    echo "3. Restart Containers"
    echo "4. Remove (including Docker & Docker Compose)"
    echo "5. Update"
    echo "6. Exit"
    echo -e "\nEnter your choice:"
    read -r choice
}

install_nextcloud() {
    echo "[Installing Nextcloud]"
    
    # Docker & Docker Compose Installation
    curl -fsSL https://get.docker.com | sh
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    
    # Deploy Nextcloud
    docker-compose up -d
}

stop_containers() {
    echo "[Stopping Nextcloud Containers]"
    docker-compose down
}

restart_containers() {
    echo "[Restarting Nextcloud Containers]"
    docker-compose down
    docker-compose up -d
}

remove_nextcloud() {
    echo "[Removing Nextcloud and Cleanup]"
    
    # Stop and Remove Docker Containers
    docker-compose down
    
    # Remove Docker & Docker Compose
    apt-get purge docker.io docker-compose -y
    apt-get autoremove -y
}

update_nextcloud() {
    echo "[Updating Nextcloud]"
    
    # Bring down the containers before updating
    docker-compose down
    
    # Pull the latest Docker Images
    docker-compose pull
    
    # Start the containers back up
    docker-compose up -d
}

while true; do
    clear
    display_ascii_art
    display_menu
    
    case "$choice" in
        1) install_nextcloud;;
        2) stop_containers;;
        3) restart_containers;;
        4) remove_nextcloud;;
        5) update_nextcloud;;
        6) echo "Exiting..."; exit 0;;
        *) echo "Invalid choice. Please select a valid option.";;
    esac
    echo "Press any key to return to the main menu..."
    read -r -n 1
done
