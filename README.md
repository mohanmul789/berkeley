# Berkeley Project

This application is to deploy a docker application on the kubernetes environment which will show the number of visitors to their website.
This application is built in AWS cloud and using Terraform to build the IaC.
To start with building the infrastructure, we will follow these steps.

 1. we first need backend environment to store the statefiles. So the first resource to be deployed is the backend which has the s3 bucket and dynamodb table.
2. After the backend is created, we will be creating the VPC to deploy our application. All the resources information are stored in output file.
3. For storing the count we need a redis server. This module redis-elasticcache is then deployed
4. This application needs to be run in eks cluster so next is our eks cluster deployment.
5. The docker application is the web-npm which needs to update with the redis cluster endpoint.

All these are in seperate folders so that each one can be updated/deployed separately.
### [](#pre-request)Pre Request

-   Terraform
-   AWS CLI
-   AWS Credential Configurations

## Terraform - init

When you run the `terraform init` command make sure to run with the configuration file as below.

#### [](#uat)UAT

`terraform init -backend-config="uat-backend.tfvars" -reconfigure`

#### [](#prod)PROD

`terraform init -backend-config="prod-backend.tfvars" -reconfigure`

## [](#terraform---workspace)Terraform - workspace

Make sure to select the appropriate workspace as below.
#### [](#uat-1)DEV

`terraform workspace select dev`

#### [](#uat-1)UAT

`terraform workspace select uat`

#### [](#prod-1)PROD

`terraform workspace select prod`

#### [](#list)LIST

To see a list of available workspaces, use below command. `terraform workspace list`

## [](#terraform---plan-and-apply)Terraform - plan and apply

When you run the `terraform plan` or ``` terraform apply commands make sure to run with the tfvars file as below.
#### [](#DEV) DEV

`terraform plan -var-file="dev.tfvars"`

`terraform apply -var-file="dev.tfvars"`

#### [](#uat)UAT

`terraform plan -var-file="uat.tfvars"`

`terraform apply -var-file="uat.tfvars"`

#### [](#prod)PROD

`terraform plan -var-file="prod.tfvars"`

`terraform apply -var-file="prod.tfvars"`

Template: .invoke-kubectlupdateconfig

Prerequisites:
Prior to using this template, you need to set up the identity provider using this tutorial: https://docs.gitlab.com/ee/ci/cloud_services/aws
Steps Add the identity provider and Configure a role and trust are required.
The configured role must have at least DescribeCluster iam permission towards the target cluster and have the required permissions in the eks's auth-config(https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

Target user:
This template allows users to invoke kubectl commands within the "script" key.  It performs assume role using an identity provider in the "before_script" key, initiates a command to create the kubeconfig file to be used by kubectl and flushes all access variables in the "after_script" key.

Add on implementation should go in:

script


See example/s:

Kubectl-Invoke: Sample usage code and Documentation

Template: .invoke-ecr-token-retrieval

Prerequisites:
Prior to using this template, you need to set up the identity provider using this tutorial: https://docs.gitlab.com/ee/ci/cloud_services/aws
Steps Add the identity provider and Configure a role and trust are required.

Target user:
This template allows users to retrieve an AWS ECR token in "before_script" key and flushes all access tokens in the "after_script" key.

Add on implementation should go in:

script


CICD Settings/Variables to set:


AWS_ECR_URL
ROLE_ARN





