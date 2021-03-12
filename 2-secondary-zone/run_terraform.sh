#!/bin/bash

set -xe 

project_id=
disk_name=disk-zo-a

# Get latest snapshot
# latest_snapshot_zonal_disk_a=$(gcloud compute snapshots list \
#     --project=${project_id} \
#     --format="value(name)" \
#     --sort-by=~creationTimestamp \
#     --filter="name ~ ${disk_name}" \
#     --limit=1)
    
# if [[ -z $latest_snapshot_zonal_disk_a ]]; then
#     echo "Latest snapshot is not available"
#     exit 1
# fi

latest_snapshot_zonal_disk_a=

# Terraform
export TF_VAR_latest_snapshot_zonal_disk_a=$latest_snapshot_zonal_disk_a
export TF_VAR_failover=true

terraform init
terraform plan
terraform apply --auto-approve
