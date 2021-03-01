#!/bin/bash

set -xe

sudo apt-get update -y
sudo apt-get install -y apache2

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

echo "Hi, This is zonal data" >> /opt/myapp/data1/test1.txt
echo "Hi, This is regional data" >> /opt/myapp/data2/test2.txt

echo "<!doctype html><html><body><h1>Hello World!</h1></body></html>" | sudo tee /var/www/html/index.html
sudo systemctl restart apache2
