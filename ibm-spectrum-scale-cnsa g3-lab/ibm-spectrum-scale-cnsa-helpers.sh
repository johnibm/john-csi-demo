# Get CNSA Version
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmfsadm dump version | head -4
# Output
# Dump level: verbose
# Build branch "5.1.1.4 ".
# Built on Oct  1 2021 at 09:13:43 by .
# Current daemon version 2504, minimum compatible version 1800

# Get CSI Version
oc logs $(oc get pods -lapp=ibm-spectrum-scale-csi -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale-csi) -c ibm-spectrum-scale-csi -n ibm-spectrum-scale-csi  | head -2

# Output
# I1103 16:57:03.530734       1 gpfs.go:68] gpfs GetScaleDriver
# I1103 16:57:03.530847       1 gpfs.go:145] gpfs SetupScaleDriver. name: spectrumscale.csi.ibm.com, version: 2.3.1, nodeID: ocp-z9xlk-compute-2
