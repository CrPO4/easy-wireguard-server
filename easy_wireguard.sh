#!/bin/bash

GREEN='\033[0;32m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

if ! [ -d "easy_wireguard" ]; then
    mkdir easy_wireguard
    echo -e "${GREEN}Downloading scripts...${NC}"
fi
cd easy_wireguard
if ! [ -f "setup_server.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/setup_server.sh
	chmod +x setup_server.sh
fi
if ! [ -f "setup_server_from_backup.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/setup_server_from_backup.sh
	chmod +x setup_server_from_backup.sh
fi
if ! [ -f "add_client.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/add_client.sh
	chmod +x add_client.sh
fi
if ! [ -f "show_qr.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/show_qr.sh
	chmod +x show_qr.sh
fi
if ! [ -f "create_backup.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/create_backup.sh
	chmod +x create_backup.sh
fi
if ! [ -f "remove_server.sh" ]; then
	curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/remove_server.sh
	chmod +x remove_server.sh
fi
cd ..

echo -en "${GREEN}Choose the action:
[1] Setup WireGuard server
[2] Setup WireGuard server from backup
[3] Add new client (peer)
[4] Show client (peer) QR
[5] Create configuration backup
${RED}[6] Remove WireGuard server from this system${GREEN}

[1/2/3/4/5/6]: ${NC}"
read OPTION

if [ $OPTION == "1" ]; then
	./easy_wireguard/setup_server.sh
elif [ $OPTION == "2" ]; then
	./easy_wireguard/setup_server_from_backup.sh
elif [ $OPTION == "3" ]; then
	./easy_wireguard/add_client.sh
elif [ $OPTION == "4" ]; then
	./easy_wireguard/show_qr.sh
elif [ $OPTION == "5" ]; then
	./easy_wireguard/create_backup.sh
elif [ $OPTION == "6" ]; then
	./easy_wireguard/remove_server.sh
	rm -r ./easy_wireguard
else
	echo -e "${PURPLE}Exit: the system was not modified.${NC}"
fi
