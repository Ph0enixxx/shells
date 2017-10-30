#!/bin/bash

# usage: sh user_add.sh radish 2333
useradd $1  -d /home/parent/$1
echo test123|passwd $1 --stdin  &>/dev/null
usermod -a  -G  dev $1
chown $1:dev  /home/parent/$1
echo "add ${1} success"
