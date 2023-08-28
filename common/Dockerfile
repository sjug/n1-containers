FROM quay.io/centos/centos:stream9

WORKDIR /root/
COPY ./ssh /root/.ssh
COPY entry.sh /root/
COPY setup.sh /root/
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
