ARG DTK_AUTO
FROM ${DTK_AUTO} as builder

WORKDIR /root/
COPY ./ssh /root/.ssh
COPY entry.sh /root/
COPY setup.sh /root/
RUN /root/setup.sh && \
    rm /root/setup.sh

ENTRYPOINT ["/root/entry.sh"]
