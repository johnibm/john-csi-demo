IC_API_KEY=xxx
#Create Resource Group
DAL_RG_NAME="OpenShift"
DAL_RG=$(ibmcloud resource group-create $DAL_RG_NAME --output json | jq -r .id)
ibmcloud target -g $DAL_RG_NAME
#Create VPC and Subnets

DAL_VPC=$(ibmcloud is vpcc dal-vpc --address-prefix-management manual --output json | jq -r .id)
DAL1_VPC_ZONE=us-south-1
DAL1_PREFIX=dal1-prefix
DAL1_CIDR=10.10.0.0/16
ibmcloud is vpc-address-prefix-create $DAL1_PREFIX $DAL_VPC $DAL1_VPC_ZONE $DAL1_CIDR

DAL2_VPC_ZONE=us-south-2
DAL2_PREFIX=dal2-prefix
DAL2_CIDR=10.20.0.0/16
ibmcloud is vpc-address-prefix-create $DAL2_PREFIX $DAL_VPC $DAL2_VPC_ZONE $DAL2_CIDR

DAL3_VPC_ZONE=us-south-3
DAL3_PREFIX=dal3-prefix
DAL3_CIDR=10.30.0.0/16
ibmcloud is vpc-address-prefix-create $DAL3_PREFIX $DAL_VPC $DAL3_VPC_ZONE $DAL3_CIDR

( set -o posix; set; set +o posix ) | grep DAL

DAL1_SUBNET=$(ibmcloud is subnetc dal1-subnet $DAL_VPC --ipv4-cidr-block 10.10.1.0/24 --zone $DAL1_VPC_ZONE --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
DAL2_SUBNET=$(ibmcloud is subnetc dal2-subnet $DAL_VPC --ipv4-cidr-block 10.20.2.0/24 --zone $DAL2_VPC_ZONE --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
DAL3_SUBNET=$(ibmcloud is subnetc dal3-subnet $DAL_VPC --ipv4-cidr-block 10.30.3.0/24 --zone $DAL3_VPC_ZONE --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
#create bastion
#add securty rule port 22
#add FIP bastion
ibmcloud is in-init bastion --private-key @~/.ssh/id_rsa

52.118.188.240
#Done

DAL_VPC=$(ibmcloud is vpc dal-vpc --output json | jq -r .id)
DAL1_VPC_ZONE=us-south-1
DAL1_PREFIX=dal1-prefix
DAL1_CIDR=10.10.0.0/16

DAL2_VPC_ZONE=us-south-2
DAL2_PREFIX=dal2-prefix
DAL2_CIDR=10.20.0.0/16

DAL3_VPC_ZONE=us-south-3
DAL3_PREFIX=dal3-prefix
DAL3_CIDR=10.30.0.0/16

( set -o posix; set; set +o posix ) | grep DAL

DAL1_SUBNET=$(ibmcloud is subnet dal1-subnet-10-10-1-0 --vpc $DAL_VPC --output json | jq -r .id)
DAL2_SUBNET=$(ibmcloud is subnet dal2-subnet-10-20-1-0 --vpc $DAL_VPC --output json | jq -r .id)
DAL3_SUBNET=$(ibmcloud is subnet dal3-subnet-10-30-1-0 --vpc $DAL_VPC --output json | jq -r .id)


SSH_KEY=$(ibmcloud is keys --output json | jq -r '.[] | select(.name == "master-ssh-key")'.id)

IMAGE_RHEL86=$(ibmcloud is images --output json | jq -r '.[] | select(.name == "ibm-redhat-8-6-minimal-amd64-4")'.id)
CEPH_NODE01=$(ibmcloud is instance-create ceph-node01 $DAL_VPC $DAL1_VPC_ZONE bx2-2x8 $DAL1_SUBNET --address 10.10.1.51 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_NODE02=$(ibmcloud is instance-create ceph-node02 $DAL_VPC $DAL1_VPC_ZONE bx2-2x8 $DAL1_SUBNET --address 10.10.1.52 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_NODE03=$(ibmcloud is instance-create ceph-node03 $DAL_VPC $DAL1_VPC_ZONE bx2-2x8 $DAL1_SUBNET --address 10.10.1.53 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_PROXY01=$(ibmcloud is instance-create ceph-proxy01 $DAL_VPC $DAL1_VPC_ZONE bx2-2x8 $DAL1_SUBNET --address 10.10.1.50 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)

CEPH_NODE04=$(ibmcloud is instance-create ceph-node04 $DAL_VPC $DAL2_VPC_ZONE bx2-2x8 $DAL2_SUBNET --address 10.20.1.51 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_NODE05=$(ibmcloud is instance-create ceph-node05 $DAL_VPC $DAL2_VPC_ZONE bx2-2x8 $DAL2_SUBNET --address 10.20.1.52 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_NODE06=$(ibmcloud is instance-create ceph-node06 $DAL_VPC $DAL2_VPC_ZONE bx2-2x8 $DAL2_SUBNET --address 10.20.1.53 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
CEPH_PROXY02=$(ibmcloud is instance-create ceph-proxy02 $DAL_VPC $DAL2_VPC_ZONE bx2-2x8 $DAL2_SUBNET --address 10.20.1.50 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)

( set -o posix; set; set +o posix ) | grep {DAL, CEPH}

DAL1_CIDR=10.10.0.0/16
DAL1_PREFIX=dal1-prefix
DAL1_SUBNET=0717-133735b9-317f-4459-9e7d-20c010c46f90
DAL1_VPC_ZONE=us-south-1
DAL2_CIDR=10.20.0.0/16
DAL2_PREFIX=dal2-prefix
DAL2_SUBNET=0727-cdf945a5-6278-45ce-b3c8-b3534b113f5b
DAL2_VPC_ZONE=us-south-2
DAL3_CIDR=10.30.0.0/16
DAL3_PREFIX=dal3-prefix
DAL3_SUBNET=0737-d7b45b37-7a90-4809-b700-6dc321e04fdb
DAL3_VPC_ZONE=us-south-3
DAL_RG_NAME=OpenShift
DAL_VPC=r006-b6c4fc85-da0c-4454-9022-173a627d426b
CEPH_NODE01=0717_c8fffd7a-62cb-4570-b8eb-a9268410517b
CEPH_NODE02=0717_53dc1200-1792-41c2-9599-9a6c465a2796
CEPH_NODE03=0717_9988cccf-ba86-4409-a0c0-5cc88d25892c
CEPH_NODE04=0727_1841b311-3594-47b4-92a6-1de65c34e917
CEPH_NODE05=0727_c36222d6-6ddf-4e3e-af39-9fcb59b13329
CEPH_NODE06=0727_8e3f842f-cf2e-4e76-8a2f-f79fbad5f55a
CEPH_PROXY01=0717_94aa710a-7638-4963-81f1-d8a24ab81237
CEPH_PROXY02=0727_f6a7ec2d-0d1b-4eee-8aec-74398010e6be




CEPH_NODE01=$(ibmcloud is in ceph-node01 $DAL_VPC $DAL1_VPC_ZONE --output json | jq -r .id)
CEPH_NODE01_NIC=$(ibmcloud is in $CEPH_NODE01 --output json | jq -r '.network_interfaces[0].id')
CEPH_NODE01_FIP=$(ibmcloud is ipc ceph-node01-ip --nic-id $CEPH_NODE01_NIC --output json | jq -r .address)


echo "Public IP for ceph-node01: "$CEPH_NODE01_FIP
echo "URL: https://" + " $CEPH_NODE01_FIP" +":8443"


#Retrieve after creation
CEPH_NODE01=$(ibmcloud is in ceph-node01 $DAL_VPC $DAL1_VPC_ZONE --output json | jq -r .id)
CEPH_NODE01_NIC=$(ibmcloud is in $CEPH_NODE01 --output json | jq -r '.network_interfaces[0].id')
CEPH_NODE01_FIP=$(ibmcloud is ip ceph-node01-ip --output json | jq -r .address)
echo "Public IP for ceph-node01: "$CEPH_NODE01_FIP
echo "URL: https://$(CEPH_NODE01_FIP):8443"



#Add block storage
#Set names
CEPH_NODE01_OSD01_NAME=ceph-node01-vol01
CEPH_NODE02_OSD01_NAME=ceph-node02-vol01
CEPH_NODE03_OSD01_NAME=ceph-node03-vol01
CEPH_NODE04_OSD01_NAME=ceph-node04-vol01
CEPH_NODE05_OSD01_NAME=ceph-node05-vol01
CEPH_NODE06_OSD01_NAME=ceph-node06-vol01

CEPH_NODE04_OSD01_ATTACH_NAME=ceph-node04-vol01-attach
CEPH_NODE05_OSD01_ATTACH_NAME=ceph-node05-vol01-attach
CEPH_NODE06_OSD01_ATTACH_NAME=ceph-node06-vol01-attach

#Create volumes
#ibmcloud is volume-create VOLUME_NAME PROFILE_NAME ZONE_NAME [--capacity CAPACITY] [--iops IOPS] [--resource-group-id RESOURCE_GROUP_ID | --resource-group-name RESOURCE_GROUP_NAME] [--tags  TAG_NAME1,TAG_NAME2,...] [--json]

CEPH_NODE01_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE01_OSD01_NAME general-purpose $DAL1_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE02_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE02_OSD01_NAME general-purpose $DAL1_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE03_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE03_OSD01_NAME general-purpose $DAL1_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE04_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE04_OSD01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE05_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE05_OSD01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE06_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE06_OSD01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)



CEPH_NODE04_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE04_OSD01_ATTACH_NAME $CEPH_NODE04 $CEPH_NODE04_OSD01_ID --auto-delete true --output json | jq -r .id)
CEPH_NODE05_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE05_OSD01_ATTACH_NAME $CEPH_NODE05 $CEPH_NODE05_OSD01_ID --auto-delete true --output json | jq -r .id)
CEPH_NODE06_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE06_OSD01_ATTACH_NAME $CEPH_NODE06 $CEPH_NODE06_OSD01_ID --auto-delete true --output json | jq -r .id)

#Create new cluster ceph-node07, ceph-node08, ceph-node09
IC_API_KEY=xxx
DAL_RG_NAME="OpenShift"
#DAL_RG=$(ibmcloud resource group-create $DAL_RG_NAME --output json | jq -r .id)
ibmcloud target -g $DAL_RG_NAME
DAL_VPC=$(ibmcloud is vpc dal-vpc --output json | jq -r .id)
DAL1_VPC_ZONE=us-south-1
DAL1_PREFIX=dal1-prefix
DAL1_CIDR=10.10.0.0/16

DAL2_VPC_ZONE=us-south-2
DAL2_PREFIX=dal2-prefix
DAL2_CIDR=10.20.0.0/16

DAL3_VPC_ZONE=us-south-3
DAL3_PREFIX=dal3-prefix
DAL3_CIDR=10.30.0.0/16

DAL1_SUBNET=$(ibmcloud is subnet dal1-subnet-10-10-1-0 --vpc $DAL_VPC --output json | jq -r .id)
DAL2_SUBNET=$(ibmcloud is subnet dal2-subnet-10-20-1-0 --vpc $DAL_VPC --output json | jq -r .id)
DAL3_SUBNET=$(ibmcloud is subnet dal3-subnet-10-30-1-0 --vpc $DAL_VPC --output json | jq -r .id)


DAL_SSH_KEY=$(ibmcloud is keys --output json | jq -r '.[] | select(.name == "master-ssh-key")'.id)

DAL_IMAGE_RHEL86=$(ibmcloud is images --output json | jq -r '.[] | select(.name == "ibm-redhat-8-6-minimal-amd64-4")'.id)

#Check ENV variables before proceeding
( set -o posix; set; set +o posix ) | grep DAL

#Output
DAL1_CIDR=10.10.0.0/16
DAL1_PREFIX=dal1-prefix
DAL1_SUBNET=0717-133735b9-317f-4459-9e7d-20c010c46f90
DAL1_VPC_ZONE=us-south-1
DAL2_CIDR=10.20.0.0/16
DAL2_PREFIX=dal2-prefix
DAL2_SUBNET=0727-cdf945a5-6278-45ce-b3c8-b3534b113f5b
DAL2_VPC_ZONE=us-south-2
DAL3_CIDR=10.30.0.0/16
DAL3_PREFIX=dal3-prefix
DAL3_SUBNET=0737-d7b45b37-7a90-4809-b700-6dc321e04fdb
DAL3_VPC_ZONE=us-south-3
DAL_IMAGE_RHEL86=r006-7ca7884c-c797-468e-a565-5789102aedc6
DAL_RG_NAME=OpenShift
DAL_SSH_KEY=r006-f256ffa1-2b28-4fb2-902b-292839497aca
DAL_VPC=r006-b6c4fc85-da0c-4454-9022-173a627d426b
#

CEPH_NODE07=$(ibmcloud is instance-create ceph-node07 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.51 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
CEPH_NODE08=$(ibmcloud is instance-create ceph-node08 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.52 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
CEPH_NODE09=$(ibmcloud is instance-create ceph-node09 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.53 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
CEPH_PROXY03=$(ibmcloud is instance-create ceph-proxy03 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.50 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)

Add block storage
#Set names
CEPH_NODE07_OSD01_NAME=ceph-node07-vol01
CEPH_NODE08_OSD01_NAME=ceph-node08-vol01
CEPH_NODE09_OSD01_NAME=ceph-node09-vol01

CEPH_NODE07_OSD01_ATTACH_NAME=ceph-node07-vol01-attach
CEPH_NODE08_OSD01_ATTACH_NAME=ceph-node08-vol01-attach
CEPH_NODE09_OSD01_ATTACH_NAME=ceph-node09-vol01-attach

#Create volumes
#ibmcloud is volume-create VOLUME_NAME PROFILE_NAME ZONE_NAME [--capacity CAPACITY] [--iops IOPS] [--resource-group-id RESOURCE_GROUP_ID | --resource-group-name RESOURCE_GROUP_NAME] [--tags  TAG_NAME1,TAG_NAME2,...] [--json]

CEPH_NODE07_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE07_OSD01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE08_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE08_OSD01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
CEPH_NODE09_OSD01_ID=$(ibmcloud is volume-create $CEPH_NODE09_OSD01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)



CEPH_NODE07_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE07_OSD01_ATTACH_NAME $CEPH_NODE07 $CEPH_NODE07_OSD01_ID --auto-delete true --output json | jq -r .id)
CEPH_NODE08_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE08_OSD01_ATTACH_NAME $CEPH_NODE08 $CEPH_NODE08_OSD01_ID --auto-delete true --output json | jq -r .id)
CEPH_NODE09_OSD01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $CEPH_NODE09_OSD01_ATTACH_NAME $CEPH_NODE09 $CEPH_NODE09_OSD01_ID --auto-delete true --output json | jq -r .id)

( set -o posix; set; set +o posix ) | grep -e DAL -e CEPH
CEPH_NODE07=0737_b6ebbdb9-7a8e-484e-86a5-690202b8c555
CEPH_NODE07_OSD01_ATTACH_ID=0737-ac7717b4-032b-4fd1-b76f-a04bd254b560
CEPH_NODE07_OSD01_ATTACH_NAME=ceph-node07-vol01-attach
CEPH_NODE07_OSD01_ID=r006-adc0ff5e-02e6-41b9-b5ba-cac45cb70506
CEPH_NODE07_OSD01_NAME=ceph-node07-vol01
CEPH_NODE08=0737_18380fe1-f09f-4130-be40-0c4685fbbed0
CEPH_NODE08_OSD01_ATTACH_ID=0737-3e6998d7-f522-411e-a9b3-7faffd7be3eb
CEPH_NODE08_OSD01_ATTACH_NAME=ceph-node08-vol01-attach
CEPH_NODE08_OSD01_ID=r006-3e3f4d26-091b-482c-815c-356197c6d1de
CEPH_NODE08_OSD01_NAME=ceph-node08-vol01
CEPH_NODE09=0737_9175f24c-7f81-4d2f-9648-9738e92e5789
CEPH_NODE09_OSD01_ATTACH_ID=0737-f21e8de9-eaf7-499a-ad76-d320771668c6
CEPH_NODE09_OSD01_ATTACH_NAME=ceph-node09-vol01-attach
CEPH_NODE09_OSD01_ID=r006-fe50330d-a0ca-442a-af4c-66a1099c3d96
CEPH_NODE09_OSD01_NAME=ceph-node09-vol01
CEPH_PROXY03=0737_a6291e9a-253b-4c03-a38c-3ffcc709b638
DAL1_CIDR=10.10.0.0/16
DAL1_PREFIX=dal1-prefix
DAL1_SUBNET=0717-133735b9-317f-4459-9e7d-20c010c46f90
DAL1_VPC_ZONE=us-south-1
DAL2_CIDR=10.20.0.0/16
DAL2_PREFIX=dal2-prefix
DAL2_SUBNET=0727-cdf945a5-6278-45ce-b3c8-b3534b113f5b
DAL2_VPC_ZONE=us-south-2
DAL3_CIDR=10.30.0.0/16
DAL3_PREFIX=dal3-prefix
DAL3_SUBNET=0737-d7b45b37-7a90-4809-b700-6dc321e04fdb
DAL3_VPC_ZONE=us-south-3
DAL_IMAGE_RHEL86=r006-7ca7884c-c797-468e-a565-5789102aedc6
DAL_RG_NAME=OpenShift
DAL_SSH_KEY=r006-f256ffa1-2b28-4fb2-902b-292839497aca
DAL_VPC=r006-b6c4fc85-da0c-4454-9022-173a627d426b

