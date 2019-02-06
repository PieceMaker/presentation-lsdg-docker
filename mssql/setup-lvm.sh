#!/usr/bin/env bash
# Create loopback device
mkdir loopback
truncate -s 20G ./loopback/mssql_data.vol
# exit
sudo losetup /dev/loop5 ./loopback/mssql_data.vol

sudo apt-get update
sudo apt-get install thin-provisioning-tools

# The next commands need to be run as root
sudo -i

# Create physical volume
pvcreate /dev/loop5
pvs -a

# Create volume group
vgcreate docker /dev/loop5
vgs -a

# Create logical thinpool
lvcreate -l 100%FREE --thinpool thin_pool docker
lvs -a

# Create logical volume
lvcreate -V 15GB --thin --name thin_volume_1 docker/thin_pool
lvs -a

# Format volume as ext4 and mount it
mkdir /mnt/mssql_data
mkfs.ext4 /dev/docker/thin_volume_1
mount /dev/docker/thin_volume_1 /mnt/mssql_data
df -h

# Perform data restore. After, the following will create a snapshot.
lvcreate -s --name thin_volume_1_snapshot docker/thin_volume_1

# Run the following to revert snapshot
umount /mnt/mssql_data
lvconvert --merge docker/thin_volume_1_snapshot
lvcreate -s --name thin_volume_1_snapshot docker/thin_volume_1
mount /dev/docker/thin_volume_1 /mnt/mssql_data