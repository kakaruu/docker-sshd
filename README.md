# Supported tags and respective `Dockerfile` links
* [`19.03.9-alpine`, `19.03.9`, `alpine`, `latest`](https://github.com/kakaruu/docker-sshd/blob/1078ed8b246bcf42136cd10aca944d4cfe6710bf/alpine-based/Dockerfile)
* [`19.03.9-alpine-dind`, `19.03.9-dind`, `alpine-dind`, `dind`](https://github.com/kakaruu/docker-sshd/blob/1078ed8b246bcf42136cd10aca944d4cfe6710bf/alpine-based/dind/Dockerfile)

# docker-sshd
이 이미지는 `Docker`와 `OpenSSH Server` 프로세스를 를 함께 실행하기 위한 이미지입니다. 공식 Docker 이미지를 토대로 만들었기 때문에 기본적으로 `Alpine`을 사용하게 됩니다. 개인적으로 Ubuntu가 익숙하여 `Ubuntu` 기반으로도 이미지를 작성할 예정입니다.

이 이미지는 다음과 같은 분들께 유용합니다.
* Docker로 시스템을 배포하고 고객지원을 위해 SSH로 시스템에 접근하되, 고객의 PC에는 영향을 주지 않고 시스템과 관련된 부분에만 접근하고 싶은 경우.
* 고객의 PC에 시스템을 배포해야할 때 필요한 기본 패키지들을 고객의 PC에 직접 설치하지 않고, 혹은 일일히 설치하지 않고 Dockerize하고 싶은 경우.
* SSH 서버를 PC에 직접 설치하고 싶지 않은 경우.

# Reference
* Alpine based: [Docker Official Image](https://hub.docker.com/_/docker)

# How to use this image
## Example of start an image
### `SSH server & DooD`(Docker out of Docker)
```sh
$ docker run --name dood-sshd -d \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v path-to-ssh-keys:/var/lib/ssh/auth_keys \
  -p  2221:22 \
  -e SSH_USERS=root,user_1:pwd1,user_2,user_3:pwd3 \
  -e AUTH_BY_KEY_USERS=root,user_2,user_3 \
  -e SUDOERS=user_1 \
  kakaruu/docker-sshd
```
### `SSH server & DinD`(Docker in Docker)
```sh
$ docker run --privileged --name dind-sshd -d \
  -e DOCKER_TLS_CERTDIR=/certs \
  -v path-to-docker-certs:/certs \
  -v path-to-ssh-keys:/var/lib/ssh/auth_keys \
  -p 2222:22 \
  -e SSH_USERS=root,user_1:pwd1,user_2,user_3:pwd3 \
  -e AUTH_BY_KEY_USERS=root,user_2,user_3 \
  -e SUDOERS=user_1 \
  kakaruu/docker-sshd:dind
```
## Environment variable
### `SSH_USERS`
`SSH_USERS`에는 SSH로 접근할 때 사용할 계정 정보를 입력합니다. 데이터는 `user_1[:pwd_1][,user_2[:pwd_2]]...[,user_n[:pwd_n]]`와 같은 형식으로 각각의 사용자를 '`,`'로 구분하고 '`:`'로 사용자명과 비밀번호를 구분합니다. 만약 이미 있는 사용자의 정보일 경우 비밀번호가 덮어쓰입니다. 비밀번호가 비어있을 경우 '`*`'로 설정됩니다.
* Format: `user_1[:pwd_1][,user_2[:pwd_2]]...[,user_n[:pwd_n]]`
* Example: `user_1:pwd_1,user_2,user_3:pwd_3`
  ```bash
  # Result
  $ cat /etc/shadow
  root:!:18377:0:::::
  . . .
  . . .
  user_1:$6$qE9DrKPGuJg...:18377:0:99999:7:::
  user_2:*:18377:0:99999:7:::
  user_3:$6$Vt2INbLf92g...:18377:0:99999:7:::
  ```

### `AUTH_BY_KEY_USERS`
`AUTH_BY_KEY_USERS`에는 SSH로 접근할 때 RSA키로 인증할 계정들을 입력합니다. 데이터는 `user_1[,user_2][,user_3]...[,user_n]`와 같은 형식으로 각각의 사용자 이름을 '`,`'로 구분합니다. 만약 존재하지 않는 사용자일 경우, 그 사용자명은 무시됩니다. 생성된 RSA키는 컨테이너 내부의 `/var/lib/ssh/auth_keys`에 `각 사용자 이름의 폴더` 속에 저장됩니다.
* Format: `user_1[,user_2][,user_3]...[,user_n]`
* Example: `user_1,user_2,user_3`
  ```bash
  # Result
  $ ls /var/lib/ssh/auth_keys/*
  /var/lib/ssh/auth_keys/user_1:
  id_rsa      id_rsa.pub

  /var/lib/ssh/auth_keys/user_2:
  id_rsa      id_rsa.pub

  /var/lib/ssh/auth_keys/user_3:
  id_rsa      id_rsa.pub
  ```

### `SUDOERS`
`SUDOERS`에는 `sudo` 실행 권한을 부여할 계정들을 입력합니다. 데이터는 `user_1[,user_2][,user_3]...[,user_n]`와 같은 형식으로 각각의 사용자 이름을 '`,`'로 구분합니다. sudo를 사용할 때 `비밀번호 입력은 필요하지 않습니다`.
* Format: `user_1[,user_2][,user_3]...[,user_n]`
* Example: `user_1,user_2,user_3`
  ```bash
  # Result
  $ cat /etc/sudoers
  . . .
  . . .
  user_1 ALL=(ALL) NOPASSWD:ALL
  user_2 ALL=(ALL) NOPASSWD:ALL
  user_3 ALL=(ALL) NOPASSWD:ALL
  ```

## Volumes
### `/var/lib/ssh/auth_keys`
사용자별 SSH키가 저장되는 곳 입니다. [`Environment variable`의 `AUTH_BY_KEY_USERS`](#auth_by_key_users)를 참고해주세요.
### 그 외
[Docker Official Image](https://hub.docker.com/_/docker) 참고