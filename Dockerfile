ARG         ALPINE_VERSION=${ALPINE_VERSION:-3.9}
FROM        alpine:${ALPINE_VERSION}

LABEL       maintainer="https://github.com/DanielNeto"

##Install ssh and iperf packets
RUN         apk update && \
            apk upgrade && \
            apk add openssh && \
            apk add iperf && \
            apk add iputils && \
            apk add net-tools && \
            apk add tcpdump && \
            apk add tcptraceroute && \
            apk add busybox-extras && \
            apk add nmap && \
            apk add hping3 --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing &&\
            mkdir -p /root/.ssh && \
            rm -rf /var/cache/apk/* /tmp/*

##Generate host keys if not presente
RUN         ssh-keygen -A

##Enable root login
RUN         sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config

##Set root password as root
RUN         echo "root:root" | chpasswd

EXPOSE      22
VOLUME      ["/etc/ssh"]
CMD         /usr/sbin/sshd -D
