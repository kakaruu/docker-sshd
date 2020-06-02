#!/bin/bash

(
  ls /usr/local/bin/run_only_first_time.sh \
    && run_only_first_time.sh
) || echo "" > /dev/null
rm -f /usr/local/bin/run_only_first_time.sh
nohup /usr/sbin/sshd -D &> /dev/null &

docker-entrypoint.sh $@