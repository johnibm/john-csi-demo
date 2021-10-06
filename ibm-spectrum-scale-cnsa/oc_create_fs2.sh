cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-jmasc-csplab-cnsa-fs2
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-jmasc-csplab
    fs: cnsa_fs2
EOF