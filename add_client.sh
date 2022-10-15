#!/bin/bash

GREEN='\033[0;32m'
PURPLE='\033[0;35m'
NC='\033[0m'

### Ask for a device name and check
### if config can be outputted as QR-code
echo -en "${GREEN}Enter device name: ${NC}"
read DEVICE_NAME
echo -en "${GREEN}Is QR-code suitable for output [y/N]? ${NC}"
read IS_QRCODE

### Create client keys
mkdir /etc/wireguard/clients
wg genkey | sudo tee /etc/wireguard/clients/$DEVICE_NAME.key | wg pubkey | sudo tee /etc/wireguard/clients/$DEVICE_NAME.key.pub

### Get constants for further actions 
SERVER_PUBLIC=$(</etc/wireguard/server_public.key)
IP_ADR=$(ip route get 8.8.8.8 | awk -F"src " 'NR==1{split($2,a," ");print a[1]}')
line=$(grep -i "ListenPort" /etc//wireguard/wg0.conf)
IFS='= '; port=($line); unset IFS; IP_PORT="$IP_ADR:${port[1]}"
DEVICE_PUBLIC=$(</etc/wireguard/clients/$DEVICE_NAME.key.pub)
DEVICE_PRIVATE=$(</etc/wireguard/clients/$DEVICE_NAME.key)
line=$( grep "Address" /etc/wireguard/wg0.conf | cut -d ' ' -f3 )
IFS='.'; SERVER_PRIVATE_IP_OCTETS=($line); unset IFS;
SERVER_PRIVATE_IP_FIRSTOCTET=SERVER_PRIVATE_IP_OCTETS[0]
SERVER_PRIVATE_IP_SECONDOCTET=SERVER_PRIVATE_IP_OCTETS[1]
SERVER_PRIVATE_IP_THIRDOCTET=SERVER_PRIVATE_IP_OCTETS[2]
line=$( tail -n 1 /etc/wireguard/wg0.conf )
IFS='.'; last_ips=($line); unset IFS;
last_ip=${last_ips[3]}; NEXT_IP=$((last_ip+=2))
echo "Server public - $SERVER_PUBLIC
Device public - $DEVICE_PUBLIC
Device private - $DEVICE_PRIVATE
Server - $IP_PORT; Next allowed IP - x.x.x.$NEXT_IP"

### Create client config
touch /etc/wireguard/clients/$DEVICE_NAME.conf
echo "[Interface]
PrivateKey = $DEVICE_PRIVATE
Address = $SERVER_PRIVATE_IP_FIRSTOCTET.$SERVER_PRIVATE_IP_SECONDOCTET.$SERVER_PRIVATE_IP_THIRDOCTET.$NEXT_IP
DNS = 1.1.1.1, 8.8.8.8

[Peer]
PublicKey = $SERVER_PUBLIC
Endpoint = $IP_PORT
AllowedIPs = 0.0.0.0/5, 8.0.0.0/7, 11.0.0.0/8, 12.0.0.0/6, 16.0.0.0/4, 32.0.0.0/3, 64.0.0.0/2, 128.0.0.0/3, 160.0.0.0/5, 168.0.0.0/6, 172.0.0.0/12, 172.32.0.0/11, 172.64.0.0/10, 172.128.0.0/9, 173.0.0.0/8, 174.0.0.0/7, 176.0.0.0/4, 192.0.0.0/9, 192.128.0.0/11, 192.160.0.0/13, 192.169.0.0/16, 192.170.0.0/15, 192.172.0.0/14, 192.176.0.0/12, 192.192.0.0/10, 193.0.0.0/8, 194.0.0.0/7, 196.0.0.0/6, 200.0.0.0/5, 208.0.0.0/4, 1.1.1.1/32, 8.8.8.8/32" > /etc/wireguard/clients/$DEVICE_NAME.conf
### We DON"T tunnel private addresses through this VPN connection, needed for simultaneous connections to other VPN servers.

### Add client info in server config
echo "
[Peer]
### $DEVICE_NAME
PublicKey = $DEVICE_PUBLIC
AllowedIPs = $SERVER_PRIVATE_IP_OCTETS[0].$SERVER_PRIVATE_IP_OCTETS[1].$SERVER_PRIVATE_IP_OCTETS[2].$NEXT_IP" >> /etc/wireguard/wg0.conf

### Restart WireGuard server
wg-quick down wg0
wg-quick up wg0
wg

### Print output data
if [ $IS_QRCODE == "y" ];
then
	apt --yes install qrencode
	qrencode -t utf8 < /etc/wireguard/clients/$DEVICE_NAME.conf
	echo -e "${PURPLE}^^^ Scan this QR-code with WireGuard App ^^^${NC}"
else 
	echo -e "${GREEN}Config for client:
${PURPLE}$(</etc/wireguard/clients/$DEVICE_NAME.conf)${NC}"
fi
