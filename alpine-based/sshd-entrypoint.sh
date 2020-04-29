#!/bin/bash

(
  ls /usr/local/bin/run_only_first_time.sh \
    && run_only_first_time.sh
) || echo "" > /dev/null
rm -f /usr/local/bin/run_only_first_time.sh

docker-entrypoint.sh $@ & /usr/sbin/sshd -D