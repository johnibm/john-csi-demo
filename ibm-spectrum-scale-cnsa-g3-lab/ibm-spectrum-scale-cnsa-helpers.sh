# Get CNSA Version
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- mmfsadm dump version | head -4
# Output
# Dump level: verbose
# Build branch "5.1.1.4 ".
# Built on Oct  1 2021 at 09:13:43 by .
# Current daemon version 2504, minimum compatible version 1800

# Get CSI Version
#Old Format
#oc logs $(oc get pods -lapp=ibm-spectrum-scale-csi -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale-csi) -c ibm-spectrum-scale-csi -n ibm-spectrum-scale-csi  | head -2
# Output
# I1103 16:57:03.530734       1 gpfs.go:68] gpfs GetScaleDriver
# I1103 16:57:03.530847       1 gpfs.go:145] gpfs SetupScaleDriver. name: spectrumscale.csi.ibm.com, version: 2.3.1, nodeID: ocp-z9xlk-compute-2

#New Format
oc logs $(oc get pods -lname=ibm-spectrum-scale-csi-operator -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale-csi) -c operator -n ibm-spectrum-scale-csi  | head -2
#2025-04-10T18:50:51.698Z        INFO    setup   Version Info    {"commit": "8bebd1a94e0d5c32576a775c2f52e3b4f610fc33"}
#2025-04-10T18:50:51.699Z        INFO    csiscaleoperator_controller.SetupWithManager    Running IBM Storage Scale CSI operator  {"version": "2.13.1"}


