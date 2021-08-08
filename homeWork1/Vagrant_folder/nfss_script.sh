#!/bin/bash
mkdir -p /nfsdirs/upload
chown vagrant:vagrant /nfsdirs/upload
echo '/nfsdirs 192.168.50.11(rw,root_squash)' > /etc/exports
systemctl enable nfs
systemctl start nfs
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=nfs3
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --permanent --add-service=mountd
firewall-cmd --reload
