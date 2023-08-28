FROM quay.io/centos/centos:stream9

WORKDIR /root/
ADD entry.sh /root/
ADD setup.sh /root/
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
