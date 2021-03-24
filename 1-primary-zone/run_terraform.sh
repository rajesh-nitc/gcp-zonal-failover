#!/bin/bash

set -xe 

project_id=
disk_name=disk-zo-b

export TF_VAR_failback=false
terraform init
terraform plan
terraform apply --auto-approve

# Get latest snapshot
# latest_snapshot_zonal_disk_b=$(gcloud compute snapshots list \
#     --project=${project_id} \
#     --format="value(name)" \
#     --sort-by=~creationTimestamp \
#     --filter="name ~ ${disk_name}" \
#     --limit=1)
    
# if [[ -z $latest_snapshot_zonal_disk_b ]]; then
#     echo "Latest snapshot is not available"
#     exit 1
# fi

latest_snapshot_zonal_disk_b=
# Terraform
export TF_VAR_latest_snapshot_zonal_disk_b=$latest_snapshot_zonal_disk_b
export TF_VAR_failback=true

terraform init
terraform plan
terraform apply --auto-approve
