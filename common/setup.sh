#!/bin/bash
#
set -x

SFNETTEST_LOCATION=https://github.com/Xilinx-CNS/cns-sfnettest/archive/refs/tags/1.6.0-rc2.tar.gz
SFNETTEST_NAME=cns-sfnettest
SFNETTEST_ARCHIVE=${SFNETTEST_NAME}.tar.gz
LINUXKI_LOCATION=https://github.com/HewlettPackard/LinuxKI/releases/download/7.7-1/linuxki-7.7-1.noarch.rpm
ONLOAD_LOCATION=https://github.com/Xilinx-CNS/onload/archive/refs/tags/v8.1.2.tar.gz
ONLOAD_NAME=onload
ONLOAD_ARCHIVE=${ONLOAD_NAME}.tar.gz


install_prereqs() {
  local EPEL_RPM=https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
  echo "Installing EPEL repo"
  dnf install -y ${EPEL_RPM}
  echo "Installing prereq RPMs"
  dnf install -y bc bpftrace dnf-plugins-core ethtool gcc gettext git glibc-langpack-en gmp-devel iproute iputils kernel-tools kmod libevent-devel make nc ncurses net-tools numactl openssh-clients openssh-server pciutils procps-ng python3-bcc rsync rt-tests screen sysstat tmux trace-cmd vim
  dnf install -y ${LINUXKI_LOCATION}
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
curl -L ${ONLOAD_LOCATION} -o ${ONLOAD_ARCHIVE}
tar xvf ${ONLOAD_ARCHIVE} && rm ${ONLOAD_ARCHIVE}
cp onload-*/scripts/* /usr/local/bin

# Get & build cns-sfnettest
curl -L "${SFNETTEST_LOCATION}" -o "${SFNETTEST_ARCHIVE}"
mkdir -p ${SNNETTEST_NAME}
tar xzf "${SFNETTEST_ARCHIVE}" -C "${SFNETTEST_NAME}" --strip-components=1 && rm "${SFNETTEST_ARCHIVE}"
cd "${SFNETTEST_NAME}"/src
make
cp -v sfnt-pingpong sfnt-stream /usr/local/bin

# Get rt-trace-bpf
git clone https://github.com/xzpeter/rt-trace-bpf.git

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

echo "LANG=en_US.UTF-8" > /etc/locale.conf
/sbin/sshd
echo "Appending new port to sshd_config"
echo "Port 2222" >> /etc/ssh/sshd_config
