#!/bin/bash
LD_PRELOAD=

#Network Tuning
network_tune() {
  local interface="$1"
  echo "ethtool: setting ${interface} parameters with ethtool"
  ethtool -C ${interface} rx-usecs 0 tx-usecs 0 adaptive-rx off
  ethtool -G ${interface} rx 4096 tx 2048
  ethtool --set-fec ${interface} encoding off

  echo "sfcaffinity: using core 1 for 1 IRQ"
  sfcaffinity_config -c 1 -v auto ${interface}
}

cpu_power() {
  #Set CPU power level
  echo "cpupower: setting CPU power level"
  cpupower -c 2-7 idle-set -d1
}

network_tune ens1f0np0
cpu_power

CUR_CPU_AFFINITY=$(taskset -cp $$ | awk -F': ' '{print $2}' )
echo "Current shell CPU affinity is ${CUR_CPU_AFFINITY}" 
FIRST_CPU_AFFINITY=$(echo ${CUR_CPU_AFFINITY} | awk -F '[^0-9]' '{print $1}')
echo "Moving this process to CPU #${FIRST_CPU_AFFINITY}"
taskset -cp "${FIRST_CPU_AFFINITY}" $$ 

SSHD_LOCATION=$(which sshd)
echo "Starting SSHD @ ${SSHD_LOCATION}"
${SSHD_LOCATION} -D "$@"
