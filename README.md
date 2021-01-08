# JMeter VM setup with Ansible

This repository contains all tools necessary to generate some Amazon Lightsail VMs to do load testing.

## Initial setup

First of all you need to install [ansible](http://docs.ansible.com/ansible/latest/intro_installation.html), [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) and some extra dependencies.

On a Ubuntu 20.04 system you can do that by executing the following :

    sudo apt-get update
    sudo apt-get install software-properties-common
    sudo apt-get install ansible
    
    pip3 install awscli
    pip3 install boto3

**NOTE**: If you get an error that awscli is already installed, check if it was installed via apt-get and if so, remove the package (apt-get remove --purge awscli).

Add $HOME/.local/bin to your $PATH :

    export PATH=~/.local/bin:$PATH

Make sure you setup awscli to connect with your Amazon credentials by executing :

    aws configure

And finally create a keypair to be used for the Lightsail VMs & upload the public key to Lightsail :

    ssh-keygen -t rsa -b 4096 -C "jmeter@domain.com" -f ~/.ssh/id_jmeter


## Run a load test

Once everything is setup correctly you should be able to create the VMs that are needed.

A test setup that is included (in vars.yml.dist) will create 3 VMs, one is the client, the other VMs are jmeter servers. You can create as many as you want.

**NOTE**: You should copy vars.yml.dist to vars.yml and edit it to fit your needs, make sure you use the correct key pair! If you do not use the AWS ubuntu image, you might have to adapt the playbooks as well ...

To create the VMs execute the following :

    ansible-playbook create-vm.yml

Once all VMs are actually running (check on the [AWS Lightsail dashboard](https://lightsail.aws.amazon.com/ls/webapp/home/resources)) you can provision all VMs by executing the following :

    ./provision.sh

To destroy the VMs (after running the load test and copying the results) execute the following :

    ansible-playbook destroy-vm.yml


## Configuration

At the time of writing the available bundle ids for Lightsail are:
- nano_2_0 (512 MB RAM, 1 vCPU)
- micro_2_0 (1 Gb RAM, 1 vCPU)
- small_2_0 (2 GB RAM, 1 vCPU)
- medium_2_0 (4 GB RAM, 2 vCPUs)
- large_2_0 (8 GB RAM, 2 vCPUs)
- xlarge_2_0 (16 GB RAM, 4 vCPUs)
- 2xlarge_2_0 (32 GB RAM, 8 vCPUs)
