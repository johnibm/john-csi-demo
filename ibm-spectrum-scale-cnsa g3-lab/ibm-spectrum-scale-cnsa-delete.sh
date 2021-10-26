oc project ibm-spectrum-scale
oc get filesystems
for fs in `oc get filesystems --no-headers | awk '{print $1}'`; do oc delete filesystem $fs; done

oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotefs show all
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmunmount scale-jmasc-csplab-cnsa-fs1 -a
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotefs delete scale-jmasc-csplab-cnsa-fs1
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotecluster show all

oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmremotecluster delete gpfs1.local


for node in `oc get node -lscale=true --no-headers | awk '{print $1}'`; do oc debug node/$node -T -- chroot /host sh -c "rm -rf /var/mmfs; rm -rf /var/adm/ras"; done

for node in `oc get node -lscale=true --no-headers | awk '{print $1}'`; do oc debug node/$node -T -- chroot /host sh -c "ls /var/mmfs; ls /var/adm/ras"; done

