FROM quay.io/centos/centos:stream9

WORKDIR /root/
#COPY 4161-ga kernel-4161-ga
COPY ./ssh /root/.ssh
COPY entry.sh /root/
COPY setup.sh /root/
COPY bashrc /root/.bashrc
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
