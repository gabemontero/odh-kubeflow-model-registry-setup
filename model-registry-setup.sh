
oc apply -f mysql-db.yaml
oc project test-database 
oc wait --for=condition=available deployment/model-registry-db --timeout=5m

# https://issues.redhat.com/browse/RHOAIENG-21954 and https://github.com/opendatahub-io/model-registry-operator/pull/216 should
# eliminate the need for this; will work with RHOAI team to see when a ODH or RHOAI operator has this change
oc apply -f odh-model-registrires-ns.yaml

oc project odh-model-registries
oc apply -k ./rhoai-model-catalog-rest -n odh-model-registries
oc apply -f registry.yaml
oc wait --for=condition=available modelregistry.modelregistry.opendatahub.io/modelregistry-public --timeout=5m

oc apply -f odh-admins.yaml

# should not be needed long term by model registry / odh-model-controller
oc set env  deployment/odh-model-controller -n opendatahub MR_SKIP_TLS_VERIFY=true
oc wait --for=jsonpath='{.status.observedGeneration}'=2 deployment/odh-model-controller -n opendatahub --timeout=300s

