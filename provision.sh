#!/usr/bin/env bash
eval "$(./yaml.sh vars.yml var_)"
echo "[vm]" > hosts.ini
for instance in ${var_vm_hosts[@]}
do
  vmip=$(aws lightsail get-instance --instance-name $instance --query 'instance.publicIpAddress' --output text)
  echo "$vmip ansible_user=ubuntu ansible_ssh_private_key_file=$HOME/.ssh/id_rsa ansible_python_interpreter=/usr/bin/python3" >> hosts.ini
done
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook provision-vm.yml -i hosts.ini
unset ANSIBLE_HOST_KEY_CHECKING
