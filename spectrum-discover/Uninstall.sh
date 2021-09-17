helm delete --purge ${db2wh_release_name} --tiller-namespace=tiller
oc delete sa/db2u role/ibm-db2warehouse-role rolebinding/ibm-db2warehouse-rolebinding
oc delete secret/${db2wh_release_name}-db2u-instance secret/${db2wh_release_name}-db2u-ldap-bluadmin

# from documenation, has errors
for pvc in $(oc get pvc | grep "spectrum-discover" | awk '{print $1}'); do oc delete pvc $pvc; done

# delete secrets
for secret in $(oc get secrets | grep "spectrum-discover" |awk '{print $1}'); do oc delete secret ${secret}; done
oc delete configmaps --all
oc delete sa --all

# modified
for pvc in `oc get pvc -n spectrum-discover --no-headers | awk '{print $1'}`; do oc delete pvc $pvc; done
# secrets 
for secret in `oc -n spectrum-discover get secrets --no-headers | awk '{print $1}'`; do oc -n spectrum-discover delete secret $secret; done
oc delete configmap istio-ca-root-cert
oc delete configmap kube-root-ca.crt
for sa in `oc -n spectrum-discover get sa --no-headers | awk '{print $1}'`; do oc -n spectrum-discover delete sa $sa; done 

# delete this as well
oc delete clusterrole system:openshift:scc:db2wh-scc
