#!/usr/bin/bash
cd /etc/yum.repos.d/
wget http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
cd ~/
yum update
reboot
yum install binutils gcc make patch libgomp glibc-headers glibc-devel kernel-headers kernel-devel dkms



