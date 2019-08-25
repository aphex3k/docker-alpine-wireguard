#!/bin/sh
cd /etc/wireguard/config

if [ ! -f wg0.conf ]
then
    wg genkey | tee privatekey
    echo "[Interface]" > wg0.conf
    echo -n "PrivateKey = " >> wg0.conf
    cat privatekey >> wg0.conf
    echo -n "#PublicKey = " >> wg0.conf
    cat privatekey | wg pubkey >> wg0.conf
    echo "#Address = 10.1.1.1/32" >> wg0.conf
    echo "#DNS = 1.1.1.1,8.8.8.8
ListenPort = 51820
SaveConfig = true

[Peer] 
#PublicKey = GtL7fZc/bLnqZldpVofMCD6hDjrK28SsdLxevJ+qtKU= 
#PresharedKey = /UwcSPg38hW/D9Y3tcS1FOV0K1wuURMbS0sesJEP5ak= 
#AllowedIPs = 0.0.0.0/0 
#Endpoint = demo.wireguard.com:51820" >> wg0.conf
    chmod 700 wg0.conf
fi

if [ -f wg0.conf ]
then
    wg-quick up /etc/wireguard/config/wg0.conf
fi

if [ ! -f /etc/ssh/ssh_host_dsa_key ]
then
    ssh-keygen -t dsa -N "" -f /etc/ssh/ssh_host_dsa_key
fi

if [ ! -f /etc/ssh/ssh_host_rsa_key ]
then
    ssh-keygen -t rsa -N "" -f /etc/ssh/ssh_host_rsa_key
fi

if [ ! -f /etc/ssh/ssh_host_ecdsa_key ]
then
    ssh-keygen -t ecdsa -N "" -f /etc/ssh/ssh_host_ecdsa_key
fi

if [ ! -f /etc/ssh/ssh_host_ed25519_key ]
then
    ssh-keygen -t ed25519 -N "" -f /etc/ssh/ssh_host_ed25519_key
fi

/usr/sbin/sshd

# USE the trap if you need to also do manual cleanup after the service is stopped,
#     or need to start multiple services in the one container
trap "echo TRAPed signal" HUP INT QUIT TERM

echo "[hit enter key to exit] or run 'docker stop <container>'"
read