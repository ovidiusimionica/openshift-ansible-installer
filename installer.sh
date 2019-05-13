#!/bin/bash

OPENSHIFT_RELEASE="3.10"
OPENSHIFT_ANSIBLE_BRANCH="release-${OPENSHIFT_RELEASE}"
MASTER_IP="192.168.150.101"
NODE01_IP="192.168.150.102"
NODE02_IP="192.168.150.103"
NODE03_IP="192.168.150.104"
APP_DNS_SUBDOMAIN="apps.example.com"
ANSIBLE_SSH_USER="vagrant"

yum -y install git net-tools bind-utils iptables-services bridge-utils bash-completion kexec-tools sos psacct
yum -y install https://releases.ansible.com/ansible/rpm/release/epel-7-x86_64/ansible-2.6.6-1.el7.ans.noarch.rpm



# Sourcing common functions
. /vagrant/common.sh


git clone -b ${OPENSHIFT_ANSIBLE_BRANCH} https://github.com/openshift/openshift-ansible.git /home/vagrant/openshift-ansible
# tar zxvf /vagrant/openshift-ansible.tar.gz -C /home/vagrant
# cd /home/vagrant/openshift-ansible && git checkout ${OPENSHIFT_ANSIBLE_BRANCH}

if [[ -f /etc/ansible/hosts ]]; then
    mv /etc/ansible/hosts /etc/ansible/hosts.bak
fi


NODE_GROUP_MASTER="openshift_node_group_name='node-config-master'"
NODE_GROUP_INFRA="openshift_node_group_name='node-config-infra'"
NODE_GROUP_COMPUTE="openshift_node_group_name='node-config-compute'"
NODE_GROUP_MASTER_INFRA="openshift_node_group_name='node-config-master-infra'"
NODE_GROUP_ALLINONE="openshift_node_group_name='node-config-all-in-one'"

cat /vagrant/ansible-hosts \
    | sed "s~{{OPENSHIFT_RELEASE}}~${OPENSHIFT_RELEASE}~g" \
    | sed "s~{{MASTER_IP}}~${MASTER_IP}~g" \
    | sed "s~{{NODE01_IP}}~${NODE01_IP}~g" \
    | sed "s~{{NODE02_IP}}~${NODE02_IP}~g" \
    | sed "s~{{NODE03_IP}}~${NODE03_IP}~g" \
    | sed "s~{{APP_DNS_SUBDOMAIN}}~${APP_DNS_SUBDOMAIN}~g" \
    | sed "s~{{ANSIBLE_SSH_USER}}~${ANSIBLE_SSH_USER}~g" \
    | sed "s~{{NODE_GROUP_MASTER}}~${NODE_GROUP_MASTER}~g" \
    | sed "s~{{NODE_GROUP_INFRA}}~${NODE_GROUP_INFRA}~g" \
    | sed "s~{{NODE_GROUP_COMPUTE}}~${NODE_GROUP_COMPUTE}~g" \
    | sed "s~{{NODE_GROUP_MASTER_INFRA}}~${NODE_GROUP_MASTER_INFRA}~g" \
    | sed "s~{{NODE_GROUP_ALLINONE}}~${NODE_GROUP_ALLINONE}~g" \
    > /etc/ansible/hosts

mkdir -p /vagrant/ansible/group_vars
cat /vagrant/ansible/vars_template.yml \
    | sed "s~{{ANSIBLE_SSH_USER}}~${ANSIBLE_SSH_USER}~g" \
    > /vagrant/ansible/group_vars/all.yml


mkdir -p /home/vagrant/.ssh
bash -c 'echo "Host *" >> /home/vagrant/.ssh/config'
bash -c 'echo "StrictHostKeyChecking no" >> /home/vagrant/.ssh/config'
cp /vagrant/keys/* /home/vagrant/.ssh/
chmod 600 /home/vagrant/.ssh/*
chown -R vagrant:vagrant /home/vagrant
