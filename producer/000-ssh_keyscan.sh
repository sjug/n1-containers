#!/bin/bash

# List of hostnames or IP addresses
HOSTS=(
    "192.168.1.1"
    "example.com"
    "172.16.0.1"
)

# File to store the collected keys
KNOWN_HOSTS_FILE="$HOME/.ssh/known_hosts"

for host in "${HOSTS[@]}"; do
    # Fetch the SSH public key from each host
    ssh-keyscan -H $host >> $KNOWN_HOSTS_FILE
done

echo "SSH keys have been added to $KNOWN_HOSTS_FILE."

