#!/bin/bash

# Install prereqs
dnf install -y iproute iputils ncurses openssh-clients openssh-server passwd procps-ng tmux

key_type_list=(rsa ecdsa ed25519)

# Loop through all host key types
for key_type in "${key_type_list[@]}"; do
  # Check if the file does not exist
  key_path=/etc/ssh/ssh_host_${key_type}_key
  if [[ ! -f "${key_path}" ]]; then
    echo "File ${key_path} does not exist. Generating key."
    # Run sshd-keygen for key_type
    /usr/libexec/openssh/sshd-keygen "${key_type}"
  else
    echo "File ${key_path} exists."
  fi
done

echo "Adding authorized key."
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQCKsZWhBDdn+bjChRthRkSrL6DqJhh/TmcD8B19taR jugs@big" > /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Changing running port of ssh server."
echo "Port 2222" > /etc/ssh/sshd_config.d/10-port.conf
