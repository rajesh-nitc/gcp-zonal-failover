#!/bin/bash

set -xe 

project_id=
source_disk_a=

# Get latest snapshot
latest_snapshot_zonal_disk_a=$(gcloud compute snapshots list \
    --project=${project_id} \
    --format="value(name)" \
    --sort-by=~creationTimestamp \
    --filter="sourceDisk ~ ${source_disk_b}" \
    --limit=1)
    
if [[ -z $latest_snapshot_zonal_disk_a ]]; then
    echo "Latest snapshot is not available"
    exit 1
fi

export TF_VAR_bootstrap=false
export TF_VAR_latest_snapshot_zonal_disk_a=$latest_snapshot_zonal_disk_a
terraform init
terraform plan
terraform apply --auto-approve
