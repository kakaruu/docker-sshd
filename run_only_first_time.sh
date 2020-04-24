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
    adduser -D ${user_name}
    [ ! -z "${user_pwd}" ] && echo "${user_name}:${user_pwd}" | chpasswd;
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