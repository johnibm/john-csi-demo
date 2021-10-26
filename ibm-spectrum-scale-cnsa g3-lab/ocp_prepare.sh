for node in `oc get nodes --no-headers | grep compute | awk '{print $1}'`; do oc label node $node scale=true; done

# node/ocp-z9xlk-compute-1 labeled
# node/ocp-z9xlk-compute-2 labeled
# node/ocp-z9xlk-compute-3 labeled

