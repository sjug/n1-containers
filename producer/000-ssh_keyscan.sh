#!/bin/bash

# List of hostnames or IP addresses
HOSTS=(
    "pstacn1-sut"
    "cstacn1-lts"
)

for host in "${HOSTS[@]}"; do
    # Connect to each host to add keys to known_hosts
    ssh $host << EOF
echo "Connected to $host"
exit
EOF
done

echo "SSH fingerprints have been added to known_hosts"

