FROM quay.io/centos/centos:stream8

WORKDIR /root/
COPY ./ssh /root/.ssh
COPY entry.sh /root/
COPY setup.sh /root/
COPY bashrc /root/.bashrc
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
