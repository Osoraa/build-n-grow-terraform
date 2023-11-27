#!/bin/bash


# sudo grep -q "^[^#]*PasswordAuthentication" /etc/ssh/sshd_config &&
# sed -i "/^[^#]*PasswordAuthentication[[:space:]]yes/c\PasswordAuthentication no" \
# /etc/ssh/sshd_config || echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

sudo apt update -y && sudo apt full-upgrade -y && sudo apt autoremove -y
