#!/bin/bash
LD_PRELOAD=

CUR_CPU_AFFINITY=$(taskset -cp $$ | awk -F': ' '{print $2}' )
echo "Current shell CPU affinity is ${CUR_CPU_AFFINITY}" 
FIRST_CPU_AFFINITY=$(echo ${CUR_CPU_AFFINITY} | awk -F '[^0-9]' '{print $1}')
echo "Moving this process to CPU #${FIRST_CPU_AFFINITY}"
taskset -cp "${FIRST_CPU_AFFINITY}" $$ 

SSHD_LOCATION=$(which sshd)
echo "Starting SSHD @ ${SSHD_LOCATION}"
${SSHD_LOCATION} -D "$@"
