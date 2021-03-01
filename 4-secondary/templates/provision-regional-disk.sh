#!/bin/bash

device_name_region=$1
sudo mount /dev/disk/by-id/google-${device_name_region} /opt/myapp/data2
