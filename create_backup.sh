hostname=$(hostname)
date=$(date +"%Y-%m-%d")
tar -czf easy-wireguard-server-$date-$hostname-backup.tar.gz /etc/wireguard
if ! [ -f "easy-wireguard-server-$date-$hostname-backup.tar.gz" ]; then
    echo "Backup created."
else
    echo "Backup creation failed."
fi
