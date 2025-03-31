systemctl restart gpfsgui
/usr/lpp/mmfs/gui/cli/lshealth --reset

#Enable for Fusion
/usr/lpp/mmfs/gui/cli/lsuser | grep ContainerOperator | grep CsiAdmin
/usr/lpp/mmfs/gui/cli/mkuser csi-storage-gui-user -p hpda123! -g CsiAdmin,ContainerOperator -e 1


#Auth 
mmauth add ibm-storage-fusion-ikybx.fusion101.hpdalab.com -k temp_id_rsa.pub
mmauth grant ibm-spectrum-scale.cp4d-1.rtp.raleigh.ibm.com -f fusion101


curl -s -k https://scale01.dal.hpdalab.com/scalemgmt/v2/cluster -u "cnsa_storage_gui_user:<password>" | grep clusterId
curl -s -k https://scale01.dal.hpdalab.com:443/scalemgmt/v2/remotemount/remoteclusters -u "cnsa_storage_gui_user:<password>"



mmlsfs fusion101 --perfileset-quota
mmchfs fusion101 -Q yes
mmlsfs fusion101 -Q
mmchconfig enforceFilesetQuotaOnRoot=yes -i
mmchconfig controlSetxattrImmutableSELinux=yes -i
mmchfs fusion101 --filesetdf
mmchfs fusion101 --auto-inode-limit

/usr/lpp/mmfs/gui/cli/lsuser | grep ContainerOperator | grep CsiAdmin
