
oc apply -f mysql-db.yaml
oc project test-database 
oc wait --for=condition=available deployment/model-registry-db --timeout=5m 

oc project odh-model-registries
oc apply -f registry.yaml
oc wait --for=condition=available modelregistry.modelregistry.opendatahub.io/modelregistry-public --timeout=5m

oc apply -f odh-admins.yaml

# should not be needed long term by model registry / odh-model-controller
oc set env  deployment/odh-model-controller -n redhat-ods-applications MR_SKIP_TLS_VERIFY=true
oc wait --for=jsonpath='{.status.observedGeneration}'=3 deployment/odh-model-controller -n redhat-ods-applications --timeout=300s

TOKEN=$(echo /var/run/secrets/kubernetes.io/serviceaccount/token)
URL=`echo "https://$(oc get routes -n istio-system -l app.kubernetes.io/name=modelregistry-public -o json | jq '.items[].status.ingress[].host | select(contains("-rest"))')" | tr -d '"'`
echo "model registry URL is ${URL}"
curl -k -H "Authorization: Bearer $TOKEN" $URL/api/model_registry/v1alpha3/registered_models
echo
