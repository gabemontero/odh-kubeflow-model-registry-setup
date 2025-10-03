#!/bin/bash
oc apply -f ./nodefeature-ns.yaml
oc create -f ./nodefeature-operatorgroup.yaml
oc apply -f ./nodefeature-subscription.yaml
while true; do
	oc get csv -o name -n openshift-nfd | grep nfd > nfd.txt
	if [ -s nfd.txt ]; then
		export NFD=$(cat nfd.txt)
		echo "nfd csv is ${NFD}}"
		break
	else
		echo "nfd.txt still emtpy"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$NFD" -n openshift-nfd --timeout=600s

oc apply -f ./kmm-ns.yaml
oc create -f ./kmm-operatorgroup.yaml
oc apply -f ./kmm-subscription.yaml
while true; do
	oc get csv -o name -n openshift-kmm | grep kernel > kmm.txt
	if [ -s kmm.txt ]; then
		export KMM=$(cat kmm.txt)
		echo "kmm csv is ${KMM}"
		break
	else
		echo "kmm.txt still emtpy"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$KMM" -n openshift-kmm --timeout=300s

oc apply -f ./nvidia-gpu-ns.yaml
oc create -f ./nvidia-gpu-operatorgroup.yaml
oc apply -f ./nvidia-gpu-subscription.yaml
while true; do
	oc get csv -o name -n nvidia-gpu-operator | grep gpu > gpu.txt
	if [ -s gpu.txt ]; then
		export GPU=$(cat gpu.txt)
		echo "gpu csv is ${GPU}"
		break
	else
		echo "gpu.txt still empty"
		sleep 5
	fi
done
oc wait --for=jsonpath='{.status.phase}'=Succeeded "$GPU" -n nvidia-gpu-operator --timeout=300s

while true; do
  oc get installplan -n nvidia-gpu-operator -o name > ip.txt
  if [ -s ip.txt ]; then
    export IP=$(cat ip.txt)
    echo "ip.txt is ${IP})"
    break
  else
    echo "ip.txt still empty"
    sleep 5
  fi
done
oc wait --for=jsonpath='{.status.phase}'=Complete "$IP" -n nvidia-gpu-operator


