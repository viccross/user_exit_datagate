#!/bin/bash
# 
# setup_ansible.sh
#
# Shell script to do some setup for the subsequent Ansible run
#
# (C) 2024 IBM Corporation
#

# Fetch some vars (?) from the JSON
zos_ip=$(jq -r '.zos_iface1_public_ip' < deployment_variables.json)

# The inventory file doesn't have a trailing line-end, which is a hassle
echo >> inventory.yaml
echo "    zos:" >> inventory.yaml
echo "      ansible_host: ${zos_ip}" >> inventory.yaml
echo "      ansible_user: ibmuser" >> inventory.yaml

echo "Ansible inventory updated."