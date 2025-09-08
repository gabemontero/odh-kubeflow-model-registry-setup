
oc apply -f mysql-db.yaml
oc project test-database 
oc wait --for=condition=available deployment/model-registry-db --timeout=5m

oc project rhoai-model-registries
oc apply -f registry-rhoai.yaml
oc wait --for=condition=available modelregistry.modelregistry.opendatahub.io/modelregistry-public --timeout=5m

oc apply -f rhods-admins.yaml

# should not be needed if your are on a cluster with cert mgmt like with ROSA
oc set env  deployment/odh-model-controller -n redhat-ods-applications MR_SKIP_TLS_VERIFY=true
sleep 60

oc get pods -n redhat-ods-applications
