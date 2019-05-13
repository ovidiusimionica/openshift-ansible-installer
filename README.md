# OpenShift Bastion (Ansible Installer) 

[![Licensed under Apache License version 2.0](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

## Overview

The `Bastion` project aims to make it easy to provision Openshift v1.10 onto existing hardware.  

## Prerequisites

- Host machine must have at least 4GB memory
- Oracle VirtualBox installed on your host machine
- Vagrant (2.0 or above) installed on your host machine
- Vagrant plugin `vagrant-hostmanager` must be installed

## Getting Started
The installer will need adjustments before proceeding.


### Configure installer.sh
Currently this project pre-configured and support the following major versions of the OKD:

- [OKD v3.10 (default)](https://github.com/openshift/origin/releases/tag/v3.11.0)
- [OKD v3.11](https://github.com/openshift/origin/releases/tag/v3.11.0)


The `Vagrantfile` uses Origin `3.10` and openshift-ansible `release-3.10` branch by default. 

The following table lists the corresponding version relationships between Origin and openshift-ansible:

| OKD version | openshift-ansible branch |
| --- | --- |
| 3.11.x | release-3.11 |
| 3.10.x | release-3.10 |


Example of needed customization of the installer.sh script

OPENSHIFT_RELEASE="3.10"
OPENSHIFT_ANSIBLE_BRANCH="release-${OPENSHIFT_RELEASE}"
MASTER_IP="192.168.150.101"
NODE01_IP="192.168.150.102"
NODE02_IP="192.168.150.103"
NODE03_IP="192.168.150.104"
... add more nodes as needed
APP_DNS_SUBDOMAIN="apps.example.com"

Please adapt the disk size of the docker registry storage.

### Configure ssh access keys

create a folder under project root directory "keys". For each node of the cluster there must be its ssh key in this folder namede like this:
```bash
master.key
node01.key
node02.key
node03.key
... add more keys as needed
```




### Bring Installer Up

```bash
$ vagrant up
```

### Install Docker on all nodes

```bash
$ vagrant ssh installer -c 'ansible-playbook /vagrant/ansible/default.yml'
```


### Install Origin Cluster Using Ansible

#### Setup the prerequisites

```bash
vagrant ssh installer -c 'ansible-playbook /home/vagrant/openshift-ansible/playbooks/prerequisites.yml'
```

#### Install the cluster

```bash
vagrant ssh installer -c 'ansible-playbook /home/vagrant/openshift-ansible/playbooks/deploy_cluster.yml'            
```


### Open Web Console

In browser of your host, open the following page: https://[MASTER_IP]:8443/ and you should see OpenShift Web Console login page. The default login account is **admin/handhand**

### Next steps

From the master node:
- change admin password
- give cluster-admin role to admin user (oc adm policy add-cluster-role-to-user cluster-admin admin)
- expose internal docker registry to the intranet
- configure storage