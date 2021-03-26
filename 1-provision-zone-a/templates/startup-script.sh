#!/bin/bash

# set -xe

sudo dpkg --configure -a
sudo apt-get update -y
sudo apt-get install -y apache2
HOSTNAME=$(hostname)
echo "<!doctype html><html><body><h1>Hostname: $HOSTNAME</h1></body></html>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2

sudo mkdir -p /opt/myapp

if [[ ! $(blkid /dev/disk/by-id/google-${device_name_zonal}) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-${device_name_zonal}
fi
if ! grep -q "/dev/disk/by-id/google-${device_name_zonal}" /etc/fstab; then
    echo "/dev/disk/by-id/google-${device_name_zonal} /opt/myapp/data1     ext4    defaults 0 0" >> /etc/fstab
fi

if [[ ! $(blkid /dev/disk/by-id/google-${device_name_region}) =~ ext4 ]]; then
    echo 'y' | mkfs.ext4 /dev/disk/by-id/google-${device_name_region}
fi
if ! grep -q "/dev/disk/by-id/google-${device_name_region}" /etc/fstab; then
    echo "/dev/disk/by-id/google-${device_name_region} /opt/myapp/data2     ext4    defaults 0 0" >> /etc/fstab
fi

mkdir -p /opt/myapp/data{1,2}
mount -a

DATE=$(date)

echo "This is zone a data at: $DATE" >> /opt/myapp/data1/test1.txt
echo "This is zone a region data at: $DATE" >> /opt/myapp/data2/test1.txt
