# john-csi-demo
 OpenShift Demos using CSI and IBM Storage 
 09/11/21


 # Cleanup

for deployment in `oc get deployment --no-headers | awk '{print $1}'`; do oc delete deployment $deployment; done 
for pvc in `oc get pvc --no-headers | grep csi | awk '{print $1}'`; do oc delete pvc $pvc; done


mmunlinkfileset fs1 .audit_log
mmdelfileset fs1 .audit_log -f
mmdf
mmdeldisk cnsa nsd_scale05_sdc