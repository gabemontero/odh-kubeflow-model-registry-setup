
oc apply -f mysql-db.yaml
oc project test-database 
oc wait --for=condition=available deployment/model-registry-db --timeout=5m

# https://issues.redhat.com/browse/RHOAIENG-21954 and https://github.com/opendatahub-io/model-registry-operator/pull/216 should
# eliminate the need for this; will work with RHOAI team to see when a ODH or RHOAI operator has this change
oc apply -f odh-model-registrires-ns.yaml

oc project odh-model-registries
oc apply -f registry.yaml
oc wait --for=condition=available modelregistry.modelregistry.opendatahub.io/modelregistry-public --timeout=5m

oc apply -f odh-admins.yaml

# should not be needed long term by model registry / odh-model-controller
oc set env  deployment/odh-model-controller -n opendatahub MR_SKIP_TLS_VERIFY=true
sleep 60

oc get pods -n opendatahub

# oc apply -f default-model-catalog-cm.yaml
# oc apply -f model-catalog-sources-cm.yaml

# oc get pods -o name | grep catalog | xargs -l -r oc delete 

