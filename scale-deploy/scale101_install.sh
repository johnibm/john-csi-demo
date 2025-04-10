DAL_RG_NAME="OpenShift"
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

SSH_KEY=$(ibmcloud is keys --output json | jq -r '.[] | select(.name == "master-ssh-key")'.id)

IMAGE_RHEL86=$(ibmcloud is images --output json | jq -r '.[] | select(.name == "ibm-redhat-8-6-minimal-amd64-4")'.id)
SCALE_NODE01=$(ibmcloud is instance-create scale01 $DAL_VPC $DAL1_VPC_ZONE bx2-2x8 $DAL1_SUBNET --address 10.10.1.60 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
SCALE_NODE02=$(ibmcloud is instance-create scale02 $DAL_VPC $DAL2_VPC_ZONE bx2-2x8 $DAL2_SUBNET --address 10.20.1.60 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)
SCALE_NODE03=$(ibmcloud is instance-create scale03 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.60 --image $IMAGE_RHEL86 --keys $SSH_KEY --output json | jq -r .id)


SCALE_NODE01=$(ibmcloud is in scale01 $DAL_VPC $DAL1_VPC_ZONE --output json | jq -r .id)
SCALE_NODE01_NIC=$(ibmcloud is in $SCALE_NODE01 --output json | jq -r '.network_interfaces[0].id')
SCALE_NODE01_FIP=$(ibmcloud is ipc scale01-ip --nic-id $SCALE_NODE01_NIC --output json | jq -r .address)
echo "Public IP for scale01: "$SCALE_NODE01_FIP
echo "URL: https://" + " $SCALE_NODE01_FIP" +":8443"


#Retrieve after creation
SCALE_NODE01=$(ibmcloud is in scale01 $DAL_VPC $DAL1_VPC_ZONE --output json | jq -r .id)
SCALE_NODE01_NIC=$(ibmcloud is in $SCALE_NODE01 --output json | jq -r '.network_interfaces[0].id')
SCALE_NODE01_FIP=$(ibmcloud is ip scale01-ip --output json | jq -r .address)
echo "Public IP for scale01: "$SCALE_NODE01_FIP
echo "URL: https://$(SCALE_NODE01_FIP):8443"

SCALE_NODE01=$(ibmcloud is in scale01 $DAL_VPC $DAL1_VPC_ZONE --output json | jq -r .id)

#Add block storage
#Set names
SCALE_NODE01_VOL01_NAME=scale01-vol01
SCALE_NODE02_VOL01_NAME=scale02-vol01
SCALE_NODE03_VOL01_NAME=scale03-vol01
SCALE_NODE01_VOL02_NAME=scale01-vol02
SCALE_NODE02_VOL02_NAME=scale02-vol02
SCALE_NODE03_VOL02_NAME=scale03-vol02
#SCALE_NODE04_VOL01_NAME=scale04-vol01
#SCALE_NODE05_VOL01_NAME=scale05-vol01
#SCALE_NODE06_VOL01_NAME=scale06-vol01

#SCALE_NODE04_VOL01_ATTACH_NAME=scale04-vol01-attach
#SCALE_NODE05_VOL01_ATTACH_NAME=scale05-vol01-attach
#SCALE_NODE06_VOL01_ATTACH_NAME=scale06-vol01-attach

#Create volumes
#ibmcloud is volume-create VOLUME_NAME PROFILE_NAME ZONE_NAME [--capacity CAPACITY] [--iops IOPS] [--resource-group-id RESOURCE_GROUP_ID | --resource-group-name RESOURCE_GROUP_NAME] [--tags  TAG_NAME1,TAG_NAME2,...] [--json]

SCALE_NODE01_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE01_VOL01_NAME general-purpose $DAL1_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE02_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE02_VOL01_NAME general-purpose $DAL2_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE03_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE03_VOL01_NAME general-purpose $DAL3_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE01_VOL02_ID=$(ibmcloud is volume-create $SCALE_NODE01_VOL02_NAME general-purpose $DAL1_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE02_VOL02_ID=$(ibmcloud is volume-create $SCALE_NODE02_VOL02_NAME general-purpose $DAL2_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE03_VOL02_ID=$(ibmcloud is volume-create $SCALE_NODE03_VOL02_NAME general-purpose $DAL3_VPC_ZONE --capacity 300 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)


#SCALE_NODE04_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE04_VOL01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)

#SCALE_NODE05_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE05_VOL01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
#SCALE_NODE06_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE06_VOL01_NAME general-purpose $DAL2_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)

SCALE_NODE01_VOL01_ATTACH_NAME=scale01-vol01-attach
SCALE_NODE01_VOL02_ATTACH_NAME=scale01-vol02-attach
SCALE_NODE02_VOL01_ATTACH_NAME=scale02-vol01-attach
SCALE_NODE02_VOL02_ATTACH_NAME=scale02-vol02-attach
SCALE_NODE03_VOL01_ATTACH_NAME=scale03-vol01-attach
SCALE_NODE03_VOL02_ATTACH_NAME=scale03-vol02-attach

SCALE_NODE01_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE01_VOL01_ATTACH_NAME $SCALE_NODE01 $SCALE_NODE01_VOL01_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE01_VOL02_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE01_VOL02_ATTACH_NAME $SCALE_NODE01 $SCALE_NODE01_VOL02_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE02_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE02_VOL01_ATTACH_NAME $SCALE_NODE02 $SCALE_NODE02_VOL01_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE02_VOL02_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE02_VOL02_ATTACH_NAME $SCALE_NODE02 $SCALE_NODE02_VOL02_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE03_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE03_VOL01_ATTACH_NAME $SCALE_NODE03 $SCALE_NODE03_VOL01_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE03_VOL02_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE03_VOL02_ATTACH_NAME $SCALE_NODE03 $SCALE_NODE03_VOL02_ID --auto-delete true --output json | jq -r .id)

#OUput

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
SCALE_NODE01_VOL01_ATTACH_NAME=scale01-vol01-attach
SCALE_NODE01_VOL01_NAME=scale01-vol01
SCALE_NODE01_VOL02_ATTACH_ID=
SCALE_NODE01_VOL02_ATTACH_NAME=scale01-vol02-attach
SCALE_NODE01_VOL02_NAME=scale01-vol02
SCALE_NODE02=0727_17feb59c-1160-4d9b-b61a-541f1d745d4e
SCALE_NODE02_VOL01_ATTACH_ID=0727-908c7efc-fa44-4532-883d-8a3c1245bd83
SCALE_NODE02_VOL01_ATTACH_NAME=scale02-vol01-attach
SCALE_NODE02_VOL01_ID=r006-4bc6d374-e138-41fe-9cab-cb9a2260ef1e
SCALE_NODE02_VOL01_NAME=scale02-vol01
SCALE_NODE02_VOL02_ATTACH_ID=0727-e5ef9b39-1e83-46cc-80e8-80554db1b857
SCALE_NODE02_VOL02_ATTACH_NAME=scale02-vol02-attach
SCALE_NODE02_VOL02_ID=r006-4847faaf-e4e6-4ebc-83d6-c022ef1c7b02
SCALE_NODE02_VOL02_NAME=scale02-vol02
SCALE_NODE03=0737_6200df0f-c317-48c8-94bf-51cbb87b1931
SCALE_NODE03_VOL01_ATTACH_ID=0737-ba899a99-b38d-4c51-8a33-02918016c6e3
SCALE_NODE03_VOL01_ATTACH_NAME=scale03-vol01-attach
SCALE_NODE03_VOL01_ID=r006-5034d838-dbda-4dd3-87d7-046c7db5c24f
SCALE_NODE03_VOL01_NAME=scale03-vol01
SCALE_NODE03_VOL02_ATTACH_ID=0737-6356ec0a-388b-40de-b4f5-8ccb7a9d0e5b
SCALE_NODE03_VOL02_ATTACH_NAME=scale03-vol02-attach
SCALE_NODE03_VOL02_ID=r006-553a9f0f-a34b-486d-91f8-d47917a628c7
SCALE_NODE03_VOL02_NAME=scale03-vol02


# /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6
10.10.1.60  scale01.dal.hpdalab.com scale01
10.20.1.60  scale02.dal.hpdalab.com scale02
10.30.1.60  scale03.dal.hpdalab.com scale03

# ssh setup

for i in {1..3}; do ssh -o StrictHostKeyChecking=no scale0$i.dal.hpdalab.com exit; done
for i in {1..3}; do ssh -o StrictHostKeyChecking=no scale0$i exit; done
for i in {1..3}; do ssh -o StrictHostKeyChecking=no scale0$i.dal.hpdalab.com yum -y install bash-completion; done


#Create new cluster SCALE-node07, SCALE-node08, SCALE-node09
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

SCALE_NODE07=$(ibmcloud is instance-create SCALE-node07 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.51 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
SCALE_NODE08=$(ibmcloud is instance-create SCALE-node08 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.52 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
SCALE_NODE09=$(ibmcloud is instance-create SCALE-node09 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.53 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)
SCALE_PROXY03=$(ibmcloud is instance-create SCALE-proxy03 $DAL_VPC $DAL3_VPC_ZONE bx2-2x8 $DAL3_SUBNET --address 10.30.1.50 --image $DAL_IMAGE_RHEL86 --keys $DAL_SSH_KEY --output json | jq -r .id)

Add block storage
#Set names
SCALE_NODE07_VOL01_NAME=SCALE-node07-vol01
SCALE_NODE08_VOL01_NAME=SCALE-node08-vol01
SCALE_NODE09_VOL01_NAME=SCALE-node09-vol01

SCALE_NODE07_VOL01_ATTACH_NAME=SCALE-node07-vol01-attach
SCALE_NODE08_VOL01_ATTACH_NAME=SCALE-node08-vol01-attach
SCALE_NODE09_VOL01_ATTACH_NAME=SCALE-node09-vol01-attach

#Create volumes
#ibmcloud is volume-create VOLUME_NAME PROFILE_NAME ZONE_NAME [--capacity CAPACITY] [--iops IOPS] [--resource-group-id RESOURCE_GROUP_ID | --resource-group-name RESOURCE_GROUP_NAME] [--tags  TAG_NAME1,TAG_NAME2,...] [--json]

SCALE_NODE07_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE07_VOL01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE08_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE08_VOL01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)
SCALE_NODE09_VOL01_ID=$(ibmcloud is volume-create $SCALE_NODE09_VOL01_NAME general-purpose $DAL3_VPC_ZONE --capacity 10 --resource-group-name $DAL_RG_NAME --output json | jq -r .id)



SCALE_NODE07_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE07_VOL01_ATTACH_NAME $SCALE_NODE07 $SCALE_NODE07_VOL01_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE08_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE08_VOL01_ATTACH_NAME $SCALE_NODE08 $SCALE_NODE08_VOL01_ID --auto-delete true --output json | jq -r .id)
SCALE_NODE09_VOL01_ATTACH_ID=$(ibmcloud is instance-volume-attachment-add $SCALE_NODE09_VOL01_ATTACH_NAME $SCALE_NODE09 $SCALE_NODE09_VOL01_ID --auto-delete true --output json | jq -r .id)

( set -o posix; set; set +o posix ) | grep -e DAL -e SCALE
SCALE_NODE07=0737_b6ebbdb9-7a8e-484e-86a5-690202b8c555
SCALE_NODE07_VOL01_ATTACH_ID=0737-ac7717b4-032b-4fd1-b76f-a04bd254b560
SCALE_NODE07_VOL01_ATTACH_NAME=SCALE-node07-vol01-attach
SCALE_NODE07_VOL01_ID=r006-adc0ff5e-02e6-41b9-b5ba-cac45cb70506
SCALE_NODE07_VOL01_NAME=SCALE-node07-vol01
SCALE_NODE08=0737_18380fe1-f09f-4130-be40-0c4685fbbed0
SCALE_NODE08_VOL01_ATTACH_ID=0737-3e6998d7-f522-411e-a9b3-7faffd7be3eb
SCALE_NODE08_VOL01_ATTACH_NAME=SCALE-node08-vol01-attach
SCALE_NODE08_VOL01_ID=r006-3e3f4d26-091b-482c-815c-356197c6d1de
SCALE_NODE08_VOL01_NAME=SCALE-node08-vol01
SCALE_NODE09=0737_9175f24c-7f81-4d2f-9648-9738e92e5789
SCALE_NODE09_VOL01_ATTACH_ID=0737-f21e8de9-eaf7-499a-ad76-d320771668c6
SCALE_NODE09_VOL01_ATTACH_NAME=SCALE-node09-vol01-attach
SCALE_NODE09_VOL01_ID=r006-fe50330d-a0ca-442a-af4c-66a1099c3d96
SCALE_NODE09_VOL01_NAME=SCALE-node09-vol01
SCALE_PROXY03=0737_a6291e9a-253b-4c03-a38c-3ffcc709b638
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

