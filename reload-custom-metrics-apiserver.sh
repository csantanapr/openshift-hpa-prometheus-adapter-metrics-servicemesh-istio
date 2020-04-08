#!/bin/bash

set -x

oc delete cm adapter-config -n custom-metrics
oc create -f deploy/manifests/custom-metrics-config-map.yaml -n custom-metrics
oc delete pod -l app=prometheus-adapter -n custom-metrics
sleep 60
oc get --raw /apis/custom.metrics.k8s.io/v1beta1 | jq .

#reload hpa p90
oc delete -f hpa-productpage-p90.yaml -n bookinfo
oc scale --replicas=1 deployment productpage-v1 -n bookinfo
oc create -f hpa-productpage-p90.yaml -n bookinfo

#reload hpa rps
#oc delete -f hpa-productpage-rps.yaml -n bookinfo
#oc scale --replicas=1 deployment productpage-v1 -n bookinfo
#oc create -f hpa-productpage-rps.yaml -n bookinfo

sleep 20
watch oc describe hpa productpage-v1 -n bookinfo


