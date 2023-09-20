#!/bin/bash
#

SFNETTEST_LOCATION=https://github.com/Xilinx-CNS/cns-sfnettest/archive/refs/tags/sfnettest-1.6.0-rc1.tar.gz
SFNETTEST_NAME=cns-sfnettest
SFNETTEST_ARCHIVE=${SFNETTEST_NAME}.tar.gz

install_prereqs() {
  dnf install -y bc dnf-plugins-core ethtool gcc git gmp-devel iproute iputils kernel-tools kmod libevent-devel make nc ncurses net-tools numactl openssh-clients openssh-server pciutils procps-ng rsync sysstat tmux
  dnf config-manager --set-enabled crb
  dnf install -y epel-release epel-next-release
  # Need report generation deps
}

install_sysjitter() {
  local DIR_NAME="cns-sysjitter"
  git clone https://github.com/Xilinx-CNS/cns-sysjitter.git
  cd ${DIR_NAME}
  make
  mv -v sysjitter /usr/local/bin
  cd ..
  rm -r ${DIR_NAME}
}

install_prereqs
install_sysjitter

# Get OpenOnload scripts
curl -L https://github.com/Xilinx-CNS/onload/archive/refs/tags/v8.1.1.tar.gz -o onload.tar.gz
tar xvf onload.tar.gz && rm onload.tar.gz
cp onload-*/scripts/* /usr/local/bin

# Get & build cns-sfnettest
curl -L "${SFNETTEST_LOCATION}" -o "${SFNETTEST_ARCHIVE}"
mkdir -p cns-sfnettest
tar xzf "${SFNETTEST_ARCHIVE}" -C "${SFNETTEST_NAME}" --strip-components=1 && rm "${SFNETTEST_ARCHIVE}"
cd "${SFNETTEST_NAME}"/src
make
cp -v sfnt-pingpong sfnt-stream /usr/local/bin

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
