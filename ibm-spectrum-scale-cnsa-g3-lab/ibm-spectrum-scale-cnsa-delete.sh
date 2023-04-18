oc project ibm-spectrum-scale
oc get filesystems
for fs in `oc get filesystems --no-headers | awk '{print $1}'`; do oc delete filesystem $fs; done

oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotefs show all
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmunmount scale-stg-storage-cnsa-fs0 -a
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotefs delete scale-stg-storage-cnsa-fs0
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotecluster show all

oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotecluster delete gpfusion101.local

# Clean Up Operator, PV, SC
oc delete -f scale_v1beta1_cluster_cr.yaml -n ibm-spectrum-scale
oc delete -f https://raw.githubusercontent.com/IBM/ibm-spectrum-scale-container-native/v5.1.1.4/generated/installer/ibm-spectrum-scale-operator.yaml
oc get pv -lapp.kubernetes.io/instance=ibm-spectrum-scale,app.kubernetes.io/name=pmcollector
oc delete pv  -lapp.kubernetes.io/instance=ibm-spectrum-scale,app.kubernetes.io/name=pmcollector
oc delete sc  -lapp.kubernetes.io/instance=ibm-spectrum-scale,app.kubernetes.io/name=pmcollector
oc delete sc ibm-spectrum-scale-sample

# Clean Up Nodes
for node in `oc get node -lscale=true --no-headers | awk '{print $1}'`; do oc debug node/$node -T -- chroot /host sh -c "rm -rf /var/mmfs; rm -rf /var/adm/ras"; done
for node in `oc get node -lscale=true --no-headers | awk '{print $1}'`; do oc debug node/$node -T -- chroot /host sh -c "ls /var/mmfs; ls /var/adm/ras"; done

oc label node --all scale.spectrum.ibm.com/role-
oc label node --all scale.spectrum.ibm.com/designation-

# Clean Up Scale Cluster
mmauth show all | grep ibm-spectrum-scale
mmauth delete ibm-spectrum-scale.cluster.local


mmlsfs fusion101 --perfileset-quota
mmchfs fusion101 -Q yes
mmlsfs fusion101 -Q
mmchconfig enforceFilesetQuotaOnRoot=yes -i
mmchconfig controlSetxattrImmutableSELinux=yes -i
mmchfs fusion101 --filesetdf
mmchfs fusion101 --auto-inode-limit