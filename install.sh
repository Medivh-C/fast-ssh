#!/bin/bash

# Environment
work_dir=$HOME"/fast-ssh/bastion"
server_conf="server.conf"

#
mkdir -p "$work_dir"
cp ./bastion/* "$work_dir"
chmod -R 755 "$work_dir"

# New configuration file
cd "$work_dir"
if [ ! -f "$server_conf" ]; then
  touch "$server_conf"
else
  read -n 2 -p "Server config file already exists! Would you want to cover it? input y/n : " choice
  if [ "$choice" == "y" ] || [ "$choice" == "Y" ]; then
    echo 1111111
    rm -rf "$server_conf"
    touch "$server_conf"
  else
    echo "The installation process was terminated!"
    exit
  fi
fi

echo "Successfully installed!"
