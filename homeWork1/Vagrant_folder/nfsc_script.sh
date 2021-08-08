#!/bin/bash
mkdir /nfsdirc
echo '192.168.50.10:/nfsdirs /nfsdirc nfs nfsvers=3,proto=udp,timeo=5,retrans=3 0 0' >> /etc/fstab
mount /nfsdirc
sudo -u vagrant touch /nfsdirc/upload/1.txt
