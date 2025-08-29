oc apply -f nfd.yaml
sleep 5
oc wait --for=condition=available nodefeaturediscovery/nfd-instance -n openshift-nfd --timeout=300s || true

oc get pods -n openshift-nfd

sleep 15

oc get nodes -o yaml | grep feature.node.kubernetes.io/pci-10de.present

# seems like even if the nfd-instance is not fully available, it is sufficient enough to launch the gpu pod
# and serve models

oc project nvidia-gpu-operator

cat <<EOF | oc apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: gpu-pod
spec:
  restartPolicy: Never
  containers:
    - name: cuda-container
      image: nvcr.io/nvidia/k8s/cuda-sample:vectoradd-cuda12.5.0
      resources:
        limits:
          nvidia.com/gpu: 1 # requesting 1 GPU
  tolerations:
  - key: nvidia.com/gpu
    operator: Exists
    effect: NoSchedule
EOF

oc wait --for=jsonpath='{.status.phase}'=Succeeded pod/gpu-pod --timeout=600s

oc logs gpu-pod

oc new-project llamastack

exit 0
