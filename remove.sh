#/bin/bash

## Logging everything into /tmp folder
exec &>> /tmp/nextcloud-speed-installer.log

## Check, if the user runned this script as root
if [ "$EUID" -ne 0 ]
then
  echo " "
  then sleep 3 && echo "[!!] Please run as root"
  echo " "
  exit
fi

## Stopping Docker Compose, and deleting volume...
sudo docker-compose down -v

# Removing docker.io and docker-compose from the system
if command -v ufw &> /dev/null
then
clear
    echo "[?] Soll Docker & Docker Compose vom System entfernt werden? (j/n)"
    echo " "
    read remove_packages
    if [ "&remove_packages" = "j" ]; then
            sleep 3
            ## Remove Packages...
            sudo apt-get remove docker.io docker-compose -y
        echo "[!!] Docker & Docker Compose wurden vom System entfernt."
        sleep 1
        else
            echo "[Info] Entfernen von Docker & Docker Compose abgebrochen."
            sleep 2
        fi
  else
        echo "[Info] Entfernen von Docker & Docker Compose abgebrochen."
        sleep 2

fi

