FROM registry.redhat.io/ubi8/ubi:latest

WORKDIR /root/
COPY ./ssh /root/.ssh
COPY entry.sh /root/
COPY setup.sh /root/
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
