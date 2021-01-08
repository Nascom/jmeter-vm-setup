#!/usr/bin/env bash
set -e

eval "$(./yaml.sh vars.yml var_)"
echo "[client]" > hosts.ini
vmclientip=$(aws lightsail get-instance --instance-name ${var_vm_client} --query 'instance.publicIpAddress' --output text)
echo "$vmclientip ansible_user=${var_vm_user} ansible_ssh_private_key_file=$HOME/.ssh/${var_vm_aws_key_pair} ansible_python_interpreter=/usr/bin/python3" >> hosts.ini
echo >> hosts.ini
echo "[servers]" >> hosts.ini
for instance in ${var_vm_servers[@]}
do
  vmip=$(aws lightsail get-instance --instance-name $instance --query 'instance.publicIpAddress' --output text)
  echo "$vmip ansible_user=${var_vm_user} ansible_ssh_private_key_file=$HOME/.ssh/${var_vm_aws_key_pair} ansible_python_interpreter=/usr/bin/python3" >> hosts.ini
done
export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook provision-vm.yml -i hosts.ini
unset ANSIBLE_HOST_KEY_CHECKING

ips=""
for instance in ${var_vm_servers[@]}
do
  vmip=$(aws lightsail get-instance --instance-name $instance --query 'instance.privateIpAddress' --output text)
  if [ "$ips" = "" ]; then
    ips+="$vmip"
  else
    ips+=",$vmip"
  fi
done

echo "You should now copy your JMeter jmx file to the client Lightsail VM (IP : $vmclientip), ssh into it, go to the apache jmeter folder and add the following parameter when you execute your load test : \"-R $ips\""
echo
echo "ie. bin/jmeter -n -t script.jmx -R $ips"
echo
