# CNSA Creating Operator User and Group

/usr/lpp/mmfs/gui/cli/lsusergrp ContainerOperator
# Already Exists
# Name              ID Role              MFA
# ContainerOperator 11 containeroperator FALSE
# EFSSG1000I The command completed successfully.
# 
/usr/lpp/mmfs/gui/cli/lsuser | grep ContainerOperator
# No user exists, so create as follows:
# /usr/lpp/mmfs/gui/cli/mkuser cnsa_storage_gui_user -p cnsa_storage_gui_password -g ContainerOperator

# Disable password expiration
# /usr/lpp/mmfs/gui/cli/chuser cnsa_storage_gui_user -e 1
# Or create with password expiration disabled:
/usr/lpp/mmfs/gui/cli/mkuser cnsa_storage_gui_user -p cnsa_storage_gui_password -g ContainerOperator -e 1

# Container Storage Interface (CSI) Configuration
/usr/lpp/mmfs/gui/cli/mkusergrp CsiAdmin --role csiadmin
/usr/lpp/mmfs/gui/cli/mkuser csi-storage-gui-user -p  csi-storage-gui-password -g CsiAdmin

mmlsfs cnsa_fs0 --perfileset-quota
mmchfs cnsa_fs0 -Q yes
mmlsfs cnsa_fs1 --perfileset-quota
mmchfs cnsa_fs1 -Q yes


# Update settings
mmchconfig enforceFilesetQuotaOnRoot=yes -i
mmchconfig controlSetxattrImmutableSELinux=yes -i
mmchfs cnsa_fs0 --filesetdf
mmchfs cnsa_fs1 --filesetdf








