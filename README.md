# Easy WireGuard Server
Script to easily configure the WireGuard server. You can select desired action in `./easy_wireguard.sh` script and it will guide you through the process.
Guaranteed to work on Ubuntu 20.04.

## Step 1: getting the script
Download and run script with:
```
curl -O https://raw.githubusercontent.com/CrPO4/easy-wireguard-server/main/setup_server.sh && chmod +x easy_wireguard.sh && ./easy_wireguard.sh
```

You will be prompted to pick the action
```
Choose the action:
[1] Setup WireGuard server
[2] Setup WireGuard server from backup
[3] Add new client (peer)
[4] Remove WireGuard server from this system
```

## Step 2: setting up WireGuard server
When prompted, enter the following:
1. WireGuard server port;
2. SSH server port;
3. Desired WireGuard server IP address.
```
Choose port for VPN, 1-65535, leave blank for random:
Enter your SSH port:
Enter your desired server private IP address, leave blank for default [10.18.0.1]:
```
After setup you will be prompted to add a new peer. 

## Alternative step 2: setting up WireGuard server from backup

## Step 3: adding a new client
```
Done! Now you need to add a few peers.
Would you like to do it now [y/n]?
```
In case of a negative answer, the reminder will appear:
```
You can add peers later by running ./easy_wireguard/add_client.sh manually.
```

After the successful generation of peer config, you'll be asked to choose fitting output: QR (for mobile) or configuration file (for desktop):
```
Enter device name: 
Is QR-code suitable for output [y/N]?
```

## Step 99: removing Wireguard server from the system

```
This script will remove WireGuard server from this machine.
Are you sure [y/N]?
```

If you need to reinstall WireGuard server run ./easy_wireguard.sh again.
