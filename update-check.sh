#! /bin/bash

# Get images version
BASE_IMAGE_NAME="bloomberg/goldpinger"
DOCKERHUB_IMAGE=$(curl https://registry.hub.docker.com/v2/repositories/bloomberg/goldpinger/tags/\?page\=$i 2>/dev/null|jq '."results"[]["name"]' | grep -v "vendor" | head -n 1 | tr -d '"')
NEWEST_IMAGE=$BASE_IMAGE_NAME:$DOCKERHUB_IMAGE
CURRENT_IMAGE=$(kubectl get daemonsets goldpinger -n monitoring -o json | jq '.spec.template.spec.containers[].image' | tr -d '"')

# Get helm chart versions
CURRENT_CHART=$(helm list goldpinger --output json | jq '.Releases[].Chart' | tr -d '"')
BASE_CHART_NAME="goldpinger"
HELM_CHART=$(helm search goldpinger --output json | jq '.[].Version' | tr -d '"')
NEWEST_CHART=$BASE_CHART_NAME-$HELM_CHART

# Set Image as pipeline variable
echo "##vso[task.setvariable variable=image]$NEWEST_IMAGE"


if [ $NEWEST_IMAGE != $CURRENT_IMAGE ] && [ $NEWEST_CHART != $CURRENT_CHART ]; then
	echo "New image version detected updating from $CURRENT_IMAGE -> $NEWEST_IMAGE"
	echo "New chart version detected updating from $CURRENT_CHART -> $NEWEST_CHART"
elif [ $NEWEST_IMAGE != $CURRENT_IMAGE ]; then
	echo "New image version detected updating from $CURRENT_IMAGE -> $NEWEST_IMAGE"
elif [ $NEWEST_CHART != $CURRENT_CHART ]; then
	echo "New chart version detected updating from $CURRENT_CHART -> $NEWEST_CHART"
else
	echo "No updates detected, setting variable: run-update to false"
	echo "##vso[task.setvariable variable=run-update]false"
fi
