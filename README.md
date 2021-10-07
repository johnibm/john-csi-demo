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



oc create configmap cacert-storage-cluster-1 --from-literal=storage-cluster-1.crt="$(openssl s_client -showcerts -connect scale01.jmasc.csplab.local:443 </dev/null 2>/dev/null|openssl x509 -outform PEM)" -n ibm-spectrum-scale