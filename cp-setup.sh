oc apply -f cluster-policy.yaml
sleep 5
oc wait --for=jsonpath='{.status.state}'=ready clusterpolicy/gpu-cluster-policy --timeout=600s

oc get pods,daemonset -n nvidia-gpu-operator

