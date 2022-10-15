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
if ! [ -f "server_backup.sh" ]; then
    curl -O https://raw.githubusercontent.com/CrPO4/easy-wireguard-server/main/create_backup.sh
	chmod +x server_backup.sh
fi
if ! [ -f "add_client.sh" ]; then
    curl -O https://raw.githubusercontent.com/crpo4/easy-wireguard-server/main/add_client.sh
	chmod +x add_client.sh
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
[4] Create configuration backup
${RED}[5] Remove WireGuard server from this system${GREEN}

[1/2/3/4/5]: ${NC}"
read OPTION

if [ $OPTION == "1" ]; then
	./easy_wireguard/setup_server.sh
elif [ $OPTION == "2" ]; then
	./easy_wireguard/setup_server_from_backup.sh
elif [ $OPTION == "3" ]; then
	./easy_wireguard/add_client.sh
elif [ $OPTION == "4" ]; then
	./easy_wireguard/server_backup.sh
elif [ $OPTION == "5" ]; then
	./easy_wireguard/remove_server.sh
	rm -r ./easy_wireguard
else
	echo -e "${PURPLE}Exit: the system was not modified.${NC}"
fi
