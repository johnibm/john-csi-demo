for node in `oc get nodes --no-headers | grep compute | awk '{print $1}'`; do oc label node $node scale=true; done
for node in `oc get nodes --no-headers | grep compute | awk '{print $1}'`; do oc label node $node app.kubernetes.io/component=scale; done
# node/ocp-z9xlk-compute-1 labeled
# node/ocp-z9xlk-compute-2 labeled
# node/ocp-z9xlk-compute-3 labeled


# Apply Machine Config 
oc apply -f https://raw.githubusercontent.com/IBM/ibm-spectrum-scale-container-native/v5.1.1.4/generated/mco/ocp4.7/mco_x86_64.yaml
