FROM golang:bullseye AS builder
ARG XRAY_UI_REPO="https://github.com/MODSBOTS-GCP/3x-ui-c"
RUN git clone ${XRAY_UI_REPO} --depth=1
WORKDIR /go/3x-ui-c
RUN go build -a -ldflags "-linkmode external -extldflags '-static' -s -w"

FROM ubuntu:20.04
LABEL org.opencontainers.image.authors="https://github.com/jvdi"
COPY --from=builder /go/3x-ui-c/x-ui /usr/local/bin/x-ui

ENV TZ=Asia/Tehran
RUN apt -qq install -y curl tzdata sudo systemd
RUN curl https://my.webhookrelay.com/webhookrelay/downloads/install-cli.sh | bash
ARG TARGETARCH
COPY --from=teddysun/xray /usr/bin/xray /usr/local/bin/bin/xray-linux-${TARGETARCH}
COPY --from=teddysun/xray /usr/share/xray/ /usr/local/bin/bin/
RUN relay login -k a3870615-f02e-46c3-b0f8-ab240a1b90af -s mGRLLeOuyvu9
RUN nohup relay connect --region eu --name mygcps & ls
VOLUME [ "/etc/x-ui" ]
WORKDIR /usr/local/bin
CMD [ "x-ui" ]
