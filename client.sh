#!/usr/bin/bash

APT_PACKAGES="net-tools bash-completion"
for package in ${APT_PACKAGES} ; do
    sudo apt install ${package}
done

# SNAP_PACKAGES="brave"
# for snaps in ${SNAP_PACKAGES} ; do
#     sudo snap install ${snaps} --classic
# done

NET_FILE="55-pem.yaml"
if [[ ! -e "$NET_FILE" ]]
    then
# Enable Interfaces on Worker Nodes This is to work around UDF, we do not have an IP associated with these interfaces so they are left shut.
cat <<EOF > 55-pem.yaml 
network:
        version: 2
        ethernets:
          ens6:
            dhcp4: no
            dhcp6: no
EOF

USERNAME=ubuntu
HOSTS="10.1.1.4 10.1.1.6 10.1.1.8
SCRIPT="sudo chmod 700 55-pem.yaml; sudo cp 55-pem.yaml /etc/netplan/; sudo netplan apply;
for HOSTNAME in ${HOSTS} ; do
    scp 55-pem.yaml ${USERNAME}@${HOSTNAME}:
    ssh -l ${USERNAME} ${HOSTNAME} "${SCRIPT}"
done

        # do work here because file $f does not exist
    fi
# Remove the Default IPv4 Route Client Traffic must route via IPv6 Interface.
sudo route del -net 0.0.0.0 gw 10.1.1.1 netmask 0.0.0.0 dev ens5
sudo route add -net 0.0.0.0 gw 10.1.10.5 netmask 0.0.0.0 dev ens6

# Change NetPlan to disable DHCP and configure static IP.
cat <<EOF > 50-cloud-init.yaml 
network:
  version: 2
  ethernets:
    ens5:
      addresses:
        - 10.1.1.4/24
      nameservers:
        addresses: [ 10.1.1.2 ]
EOF

sudo cp 50-cloud-init.yaml /etc/netplan/50-cloud-init.yaml

sudo netplan apply
