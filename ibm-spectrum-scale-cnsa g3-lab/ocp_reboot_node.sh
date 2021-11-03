oc adm cordon $node
oc adm drain $node --ignore-daemonsets --delete-emptydir-data --force


oc debug node/$node -T -- chroot /host sh -c systemctl reboot
oc debug node/$node -T -- chroot /host sh -c "shutdown -f now"


nodes=$(oc get nodes -o jsonpath='{.items[*].metadata.name}')
for node in ${nodes[@]}
do
    echo "==== Shut down $node ===="
    ssh core@$node sudo shutdown -h 1
done






# List nodes, these must all be in Ready status

oc get nodes -l node-role.kubernetes.io/master
oc get nodes -l node-role.kubernetes.io/worker

# List cluster operators, there should be none in Degraded status
oc get clusteroperators

