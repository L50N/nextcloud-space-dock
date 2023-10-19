#/bin/bash

## Check, if the user runned this script as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        sleep 3
        echo "This script must be run as root."
        exit 1
    fi
}

## Installing needed packages (In this case, docker & docker-compose)
clear
echo "[1.] Installing needed packages..."
sleep 2
sudo apt-get update -y
sudo apt-get install docker.io docker-compose -y
clear

## If UFW is installed on the system, we allow the needed ports for Nextcloud
echo "[2.] Checking, if UFW is installed on the system..."
if command -v ufw &> /dev/null
then
    clear
    echo "[?] Sollen die passenden Regeln für UFW freigegeben werden? (j/n)"
    read add_rules
    if [ "&add_rules" = "j" ]; then
            sleep 3
            ## Allowing the needed UFW Ports
            sudo ufw allow 80
            sudo ufw allow 443
            sudo ufw allow 81
            sudo ufw allow 6200
            sudo ufw allow 3306
        echo "[!!] Die benötigten Ports für die Installation wurden erlaubt."
        sleep 1
    else
        echo "[!!] Ein Fehler ist aufgetreten.."
        sleep 3
    fi
else
    echo "[!!] Es konnte keine Installation von UFW auf deinem System festgestellt werden."
    sleep 2
fi

## Installing Nextcloud via Docker on the system
clear
echo "[3.] Installiere Nextcloud, MariaDB und den NGINX-Proxy-Manager mit Docker auf dem System..."
    sleep 2
    sudo docker-compose up -d
    sleep 3
clear

echo "[Installation] Fertig. Nun, öffne https://localhost:6200 im Browser und folge den Anweisungen. Außerdem wurde noch ein NGINX-Proxy-Manager aufgesetzt, welchen du unter https://localhost:81 erreichen kannst. Dort kannst du dein SSL Zertifikat generieren, sowie auch deine Domain direkt verbinden."
echo "[<3] Script made by L5ON"
    sleep 1
    echo "15..."
    sleep 1
    echo "14..."
    sleep 1
    echo "13..."
    sleep 1
    echo "12..."
    sleep 1
    echo "11..."
    sleep 1
    echo "10..."
    sleep 1
    echo "9..."
    sleep 1
    echo "8..."
    sleep 1
    echo "7..."
    sleep 1
    echo "6..."
    sleep 1
    echo "5..."
    sleep 1
    echo "4..."
    sleep 1
    echo "3..."
    sleep 1
    echo "2..."
    sleep 1
    echo "1..."
    sleep 1
    echo "0..."
    clear
exit
