# JMeter VM setup with Ansible

This repository contains all tools necessary to generate some Amazon Lightsail VMs to do load testing.

First of all you need to install [ansible](http://docs.ansible.com/ansible/latest/intro_installation.html), [awscli](http://docs.aws.amazon.com/cli/latest/userguide/installing.html) and some extra dependencies.

On a Ubuntu 16.04 system you can do that by executing the following :

    sudo apt-get update
    sudo apt-get install software-properties-common
    sudo apt-add-repository ppa:ansible/ansible
    sudo apt-get update
    sudo apt-get install ansible
    
    pip install awscli
    
    pip install boto3
    
Make sure you setup awscli to connect with your Amazon credentials by executing :

    aws configure
    
Once everything is setup correctly you should be able to create the VMs that are needed.

A test setup that is included (in vars.yml.dist) will create 2 VMs, but you can create as many as you want.

**NOTE**: You should copy vars.yml.dist to vars.yml and edit it to fit your needs, make sure you use the correct key pair!

To create the VMs execute the following :

    ansible-playbook create-vm.yml
    
To destroy the VMs execute the following :

    ansible-playbook destroy-vm.yml

