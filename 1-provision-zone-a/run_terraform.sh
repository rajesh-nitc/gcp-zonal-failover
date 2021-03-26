#!/bin/bash

set -xe 

project_id=
disk_name=app1-di-zo-b

# Get latest snapshot
latest_snapshot_zonal_disk_b=$(gcloud compute snapshots list \
    --project=${project_id} \
    --format="value(name)" \
    --sort-by=~creationTimestamp \
    --filter="name ~ ${disk_name}" \
    --limit=1)
    
if [[ -z $latest_snapshot_zonal_disk_b ]]; then
    echo "Latest snapshot is not available"
    exit 1
fi

export TF_VAR_bootstrap=false
export TF_VAR_latest_snapshot_zonal_disk_b=$latest_snapshot_zonal_disk_b
terraform init
terraform plan
terraform apply --auto-approve