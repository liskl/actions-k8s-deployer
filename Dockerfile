FROM alpine:3.12

# Set timezone to UTC by default
RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

# Note: Latest version of kubectl may be found at:
# https://github.com/kubernetes/kubernetes/releases
RUN apk -v --update add --no-cache ca-certificates bash git openssh curl py-pip groff less mailcap \
    && wget -q https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -O /usr/bin/kubectl \
    && chmod +x /usr/bin/kubectl \
    && pip install --upgrade awscli s3cmd python-magic \
    && apk -v --purge del py-pip ;

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]