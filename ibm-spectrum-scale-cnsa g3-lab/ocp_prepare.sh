for node in `oc get nodes --no-headers | grep compute | awk '{print $1}'`; do oc label node $node scale=true; done
for node in `oc get nodes --no-headers | grep compute | awk '{print $1}'`; do oc label node $node app.kubernetes.io/component=scale; done
# node/ocp-z9xlk-compute-1 labeled
# node/ocp-z9xlk-compute-2 labeled
# node/ocp-z9xlk-compute-3 labeled


# Apply Machine Config 
oc apply -f https://raw.githubusercontent.com/IBM/ibm-spectrum-scale-container-native/v5.1.1.4/generated/mco/ocp4.7/mco_x86_64.yaml


# Test Scale nodes
# Set hostname for the GUI node on the storage cluster:
scale_node=scale01.stg-storage.local
# this will fail because there is no resolution from the worker node
oc debug node/$(oc get nodes -lscale=true -o jsonpath='{.items[0].metadata.name}') -T -- chroot /host sh -c "ping -c 5 $scale_node"
# this should succeed as the core pod will use the OCP Cluster DNS configuration:
oc exec $(oc get pods -lapp.kubernetes.io/name=core -ojsonpath="{.items[0].metadata.name}" -n ibm-spectrum-scale) -c gpfs -n ibm-spectrum-scale -- ping -c 5 $scale_node

