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

echo "    zos:" >> inventory.yaml
echo "      ansible_host: ${zos_ip}" >> inventory.yaml
echo "      ansible_user: ibmuser" >> inventory.yaml

echo "Ansible inventory updated."
exit 0
