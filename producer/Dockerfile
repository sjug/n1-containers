FROM n1-base

COPY 000-ssh_keyscan.sh /root/
COPY ./ssh /root/.ssh
RUN find /root/.ssh -type f -exec chmod 600 {} +
