cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-stg-storage-cnsa-fs0
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-stg-storage
    fs: cnsa_fs0
EOF
cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-stg-storage-cnsa-fs1
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-stg-storage
    fs: cnsa_fs1
EOF

cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-stg-storage-cnsa-fs2
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-stg-storage
    fs: cnsa_fs2
EOF

