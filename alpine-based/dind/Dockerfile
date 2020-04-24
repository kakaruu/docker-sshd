FROM docker:19.03.8-dind
LABEL maintainer="Jaeho Lee <ljh@coever.co.kr>"

ENV SSH_USERS ""
ENV NO_PASSWD_USERS ""
ENV SUDOERS ""

RUN set -eux; \
  apk --update --no-cache add \
    nano \
    git \
    curl \
    openssh-server \
    docker-compose \
    easy-rsa \
    bash \
    sudo

RUN ssh-keygen -A

COPY alpine-based/dind/sshd-entrypoint.sh /usr/local/bin/
COPY run_only_first_time.sh /usr/local/bin/

EXPOSE 22

ENTRYPOINT ["sshd-entrypoint.sh"]