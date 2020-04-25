#!/bin/bash

function mfcb { local val="$4"; "$1"; eval "$2[$3]=\$val;"; };
function val_ltrim { if [[ "$val" =~ ^[[:space:]]+ ]]; then val="${val:${#BASH_REMATCH[0]}}"; fi; };
function val_rtrim { if [[ "$val" =~ [[:space:]]+$ ]]; then val="${val:0:${#val}-${#BASH_REMATCH[0]}}"; fi; };
function val_trim { val_ltrim; val_rtrim; };
function split { local -n array="$3" || return 1; readarray -c1 -C 'mfcb val_trim array' -td$2 <<<"$1$2"; unset 'array[-1]'; echo "Results are stored in '$3'."; };

function add_user
{
  local user_detail
  split "$1" ":" user_detail > /dev/null
  local user_name=${user_detail[0]}
  local user_pwd=${user_detail[1]}
  if [ ! -z "${user_name}" ]
  then
    adduser -D ${user_name} || echo "" > /dev/null
    if [ -z "${user_pwd}" ]
    then
      usermod -p '*' ${user_name}
    else
      echo "${user_name}:${user_pwd}" | chpasswd;
    fi
  fi
}

function create_auth_key
{
  local key_path=/etc/ssh/auth_keys/$1
  local home_path=`eval echo ~$1`
  if [ "${home_path}" != "~$1" ]
  then
    mkdir -p -m 600 ${key_path}
    mkdir -p ${home_path}/.ssh
    ssh-keygen -t rsa -f ${key_path}/id_rsa -q -P "" -C ""
    cp -f ${key_path}/id_rsa.pub ${home_path}/.ssh/authorized_keys
    chown -R ${1}:${1} ${home_path}/.ssh
  fi
}

# Add users
split "$SSH_USERS" "," users > /dev/null
for user in "${users[@]}"
do
  add_user $user || echo "" > /dev/null
done

# Add sudo rules
split "$SUDOERS" "," sudoers > /dev/null
for sudoer in "${sudoers[@]}"
do
  echo "${sudoer} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
done

# Create SSH authorized keys
split "$NO_PASSWD_USERS" "," no_pwd_users > /dev/null
for user in "${no_pwd_users[@]}"
do
  create_auth_key $user || echo "" > /dev/null
done