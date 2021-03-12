# gcp-failover

### Provision zone a
```
cd 1*
terraform init
terraform plan
terraform apply --auto-approve
```

### Provision zone b
```
cd 2*
terraform init
terraform plan
terraform apply --auto-approve
```

### Failover to zone b:

Manually stop instance in zone a and then:

```
cd 2*
./run_terraform.sh

```

### Failback to zone a:

Manually stop instance in zone b and then:
```
cd 1*
./run_terraform.sh

```
