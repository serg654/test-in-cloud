#!/bin/bash

dnf update -y
dnf install -y openmpi nftables
dnf clean all
sed -r -i \"s|#include|include|\" /etc/sysconfig/nftables.conf
mv /dev/shm/main.nft /etc/nftables/main.nft
systemctl enable nftables
systemctl start nftables
bash -c 'echo "export PATH=/usr/lib64/openmpi/bin:$PATH" >> /etc/profile'
echo "sys_user ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/sys-user
useradd sys_user
sudo -u sys_user bash -c 'mkdir ~/.ssh && touch ~/.ssh/authorized_keys && \
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys && \
ssh-keygen -t rsa -b 2048 -N "" -f ~/.ssh/id_rsa && \
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9FcbtyUHkhCDEuuCypdMSkye3lRymmMNisEIPT1xlsFNN/9+nWSmtAYDZYgyG/rVPUmUF1+yPb3v40/7l0IWbHKRT91AIA5imi8G4QYEOC9T1XjE/xavPJppGtSP2UPQwCSF2kFguiltCoYn9D27Wnn0l9t1sp1xBFUjraYNRWJo5d0mHaF2+rUhM8ryIv5pgerkMRucouYnMfH9vVzRK/Lnjc2yQcqWZxyd00zpg1CcDhRpcGhhryuoE0guH74JKFmbynAo4P6I6Uy7wn3MsELbE1h0gleFn03BZvJP3Ch7lqFBHIPDPExG7YsF4eo+y56H7PqWellpJUQRH9J2P sergey.khvorov" >> ~/.ssh/authorized_keys'

