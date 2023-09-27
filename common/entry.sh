#!/bin/bash
LD_PRELOAD=
echo "Starting SSHD @ $(which sshd)"
/sbin/sshd -D "$@"
