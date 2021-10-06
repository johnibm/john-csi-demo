cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-jmasc-csplab-cnsa-fs1
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-jmasc-csplab
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
  name: scale-jmasc-csplab-cnsa-fs2
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-jmasc-csplab
    fs: cnsa_fs2
EOF

cat << EOF | oc apply -f -
---
apiVersion: scale.spectrum.ibm.com/v1beta1
kind: Filesystem
metadata:
  labels:
    app.kubernetes.io/instance: ibm-spectrum-scale
    app.kubernetes.io/name: cluster
  name: scale-jmasc-csplab-cnsa-fs3
  namespace: ibm-spectrum-scale
spec:
  remote:
    cluster: scale-jmasc-csplab
    fs: cnsa_fs3
EOF