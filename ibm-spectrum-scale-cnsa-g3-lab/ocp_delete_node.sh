oc adm cordon $node
oc adm drain $node --ignore-daemonsets --delete-local-data --force

oc debug node/$node -T -- chroot /host sh -c "shutdown -f now"


# List nodes, these must all be in Ready status

oc get nodes -l node-role.kubernetes.io/master
oc get nodes -l node-role.kubernetes.io/worker

# List cluster operators, there should be none in Degraded status
oc get clusteroperators

