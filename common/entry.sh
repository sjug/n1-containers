#!/bin/bash
LD_PRELOAD=
/sbin/sshd -D "$@"
