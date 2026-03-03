#!/usr/bin/bash

APT_PACKAGES="net-tools bash-completion"
for package in ${APT_PACKAGES} ; do
    sudo apt install ${package}
done

# SNAP_PACKAGES="brave"
# for snaps in ${SNAP_PACKAGES} ; do
#     sudo snap install ${snaps} --classic
# done