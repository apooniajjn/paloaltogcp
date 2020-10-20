# Deploy PAN OS VM on GCP 

This module deploys Palo Alto Networks Series Firewall on Google Cloud with two tier applications (Web and Databse) using Terraform:

Software versions: 
- PAN OS VM (8.1.0)
- Terraform Version (v0.12.23)
- Google provider mentioned in `main.tf` file 

## Pre-Req

You need to fulfill below pre-requisites before using this repo: 

1. Create a project on GCP 
2. Create a service account key JSON file which we will use to setup our env 
3. Download that key file and rename it `credentials.json` file and place in this home directory 
   - Pay attention to this stuff since without file you won't be able to use this repo.
4. Update your public key path in `variables.tf` file
   - update your GCP project name too
5. Terraform is installed and functional.

## How to use it 

We have added all resources in `main.tf` file and `variable.tf` file includes variables which we are using. 

In this section we will include necessary steps which you can follow to deploy your environment:

1. Run `terraform init` command 
2. Run `terraform apply` command and confirm using `yes` 

Your environment should be up and commands should run successfully. 

If you wish to destroy you can run `terraform destroy` command to do so. 

## What does it deploy in a Nut Shell 

It deploys below components on your GCP project. 

1. Create 4 different VPC networks and subnets (db, web, untrust, management)
2. Add required firewall rules to support this use case
3. Create storage buckets to store bootstrap files of VMs (Palo Alto VM, DB VM, Web VM ) 
   - Currently DB VM and Web VM bootstrap files requires some changes so I used nginx startup script only on both VMs
4. Create individual VMs (Firewall VM, DB VM, Web VM)
5. Create Cloud NAT gateways so VMs in private subnet can connect to internet if needed (nginx package download)
6. We are assigning public IP to management interface of Firewall VM so user can connect to it over UI or SSH if needed. (ease of Use)

## Open Items 

Below are few open items which will be solved in future: 

1. Palo Alto VM bootstrap bucket needs to have all required folders (license, content, software ) along with config.
2. Enhance it to match it to a production use-case. (Add Firewall Configuration Steps too if needed)