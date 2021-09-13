Required adding SCC
oc add policy add-scc-to-user anyuid -z default --as=system:admin
oc adm policy add-scc-to-user spectrum-scale-csiaccess -z default --as=system:admin
