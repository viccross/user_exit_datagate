#!/bin/bash
VERSION="6.3.0"
PVC_NAME="datagate-pvc"
INSTANCE_NAME="dg1"
NAMESPACE="cpd"
ROUTE_PORT="443"
BUCKET_ID="$BUCKETID"
BUCKET_REGION="$BUCKETRGN"
BUCKET_ENDPOINT="https://s3.$BUCKETRGN.cloud-object-storage.appdomain.cloud"
HOST_PREFIX="dg1"
export CLUSTER_HOST=$(oc get routes -n cpd | grep -i common-web-ui | awk '{print $2}' | awk -F'.' '{print $2"."$3".containers.appdomain.cloud"}')

echo "BUCKET_ID=$BUCKET_ID"

CPD_TOKEN=$(curl -X "POST" -k \
    --url "https://cpd-$NAMESPACE.$CLUSTER_HOST/icp4d-api/v1/authorize" \
    --header "Cache-Controlontrol: no-cache" \
    --header "Content-Type: application/json" \
    --data "{
    \"username\": \"$CPD_USER\",
    \"password\": \"$CPD_PASSWORD\"
    }" | jq -r ".token")

echo "CPD_TOKEN="$CPD_TOKEN
if [ -n "$CPD_TOKEN" ] && [ "$CPD_TOKEN" != "null" ]; then
    echo "Successfully logged in into Cloud Pak for Data with user $CPD_USER"
else
    echo "Error logging in. Exiting." >&2
    exit 1
fi

echo $CLUSTER_HOST


GET_WXD_INSTANCE_RESPONSE=$(curl -X "GET" -k \
  --url "https://cpd-$NAMESPACE.$CLUSTER_HOST/zen-data/v3/service_instances?fetch_all_instances=true&addon_type=watsonx-data" \
  -H "Accept: application/json" \
  -H "Authorization: Bearer $CPD_TOKEN")

echo "GET_WXD_INSTANCE_RESPONSE=$GET_WXD_INSTANCE_RESPONSE"

WXD_INSTANCE_ID=$(echo $GET_WXD_INSTANCE_RESPONSE | jq -r ".service_instances[0].id")

echo "WXD_INSTANCE_ID=$WXD_INSTANCE_ID"



DATA="{
    \"addon_type\": \"dg\",
    \"addon_version\": \"$VERSION\",
    \"display_name\": \"$INSTANCE_NAME\",
    \"namespace\": \"$NAMESPACE\",
    \"pre_existing_owner\": false,
    \"create_arguments\": {
        \"resources\": {
            \"cpu\": \"3\",
            \"memory\": \"12\"
        },
        \"metadata\": {
            \"images_ui_limit_cpu\": \"100m\",
            \"images_apply_request_cpu\": \"1000m\",
            \"targetDbEncoding\": \"UNICODE\",
            \"tundra_arrow_memory_limit_datagate_cdc_agent_watsonx\": \"250000000\",
            \"pod_affinity\": false,
            \"images_server_request_cpu\": \"1000m\",
            \"targetDbInstance\": \"watsonx.data-$WXD_INSTANCE_ID\",
            \"images_server_request_memory\": \"3Gi\",
            \"is_production_instance\": false,
            \"target_type\": \"watsonx.data\",
            \"cpu\": \"3\",
            \"storage_existingClaim_name\": \"$PVC_NAME\",
            \"images_apply_request_memory\": \"6.25Gi\",
            \"baseNamespace\": \"$NAMESPACE\",
            \"name\": \"IBM Data Gate for watsonx Non-production\",
            \"images_iceberg_server_limit_cpu\": \"300m\",
            \"images_api_request_cpu\": \"300m\",
            \"route_data_gate_route_port\": \"$ROUTE_PORT\",
            \"images_apply_limit_cpu\": \"1000m\",
            \"images_stunnel_request_cpu\": \"300m\",
            \"licenseAgreementTimestamp\": \"$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")\",
            \"enable_resource_validation\": false,
            \"databaseSecureJdbcPort\": \"1234\",
            \"images_server_limit_cpu\": \"1000m\",
            \"data_gate_database_name\": \"$BUCKET_ID\",
            \"bucket_id\": \"$BUCKET_ID\",
            \"images_ui_request_cpu\": \"100m\",
            \"dataGateInstanceName\": \"$INSTANCE_NAME\",
            \"mem\": \"12\",
            \"arch\": \"amd64\",
            \"tundra_arrow_memory_limit_datagate_apply\": \"2400000000\",
            \"route_data_gate_route_host_name\": \"$HOST_PREFIX.$CLUSTER_HOST\",
            \"databaseEngineService\": \"$BUCKET_ID\",
            \"version\": \"$VERSION\",
            \"images_api_limit_cpu\": \"300m\",
            \"images_stunnel_limit_cpu\": \"300m\",
            \"tundra_arrow_memory_limit_datagate_server\": \"2400000000\",
            \"images_server_limit_memory\": \"3Gi\",
            \"type\": \"dg\",
            \"defaultRouteSubdomain\": \"$CLUSTER_HOST\",
            \"images_apply_limit_memory\": \"6.25Gi\",
            \"source_type\": \"db2z\",
            \"storage_type\": \"existingClaim\",
            \"images_iceberg_server_request_cpu\": \"300m\",
            \"storage_storageclass_size\": \"50Gi\"
        }
    }
}"



echo "DATA=$DATA"


SUPPORTED_DG_ADDONS_VERSION=$(curl -X "POST" -k \
    --url "https://cpd-$NAMESPACE.$CLUSTER_HOST/zen-data-ui/v1/addOn/query" \
    -H "Authorization: Bearer $CPD_TOKEN" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    --data "{\"type\": \"dg\"}" | jq ".requestObj[0].Version" )

echo "SUPPORTED_DG_ADDONS_VERSION=$SUPPORTED_DG_ADDONS_VERSION"

INSTANCE_CREATION_RESPONSE=$(curl -X "POST" -k \
    --url "https://cpd-$NAMESPACE.$CLUSTER_HOST/zen-data/v3/service_instances" \
    -H "Authorization: Bearer $CPD_TOKEN" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    --data "$DATA")

echo "INSTANCE_CREATION_RESPONSE=$INSTANCE_CREATION_RESPONSE"

INSTANCE_ID=$(echo $INSTANCE_CREATION_RESPONSE | jq -r ".id")

if [ -n "$INSTANCE_ID" ] && [ "$INSTANCE_ID" != "null" ]; then
    echo "Successfully created a CR dg$INSTANCE_ID in namespace $NAMESPACE"
else
    echo "Error creating a CR. Exiting." >&2
exit 1
fi

oc create cm "dg-$INSTANCE_ID-configuration-cm" -n "$NAMESPACE" \
    --from-literal "s3_bucket_name=$BUCKET_ID" \
    --from-literal "s3_endpoint=$BUCKET_ENDPOINT" \
    --from-literal "s3_region=$BUCKET_REGION"

if [ -z "$ACCESS_KEY" ]; then
read -s -p "Bucket access key: " ACCESS_KEY
echo "\n"
fi

if [ -z "$SECRET_KEY" ]; then
    read -s -p "Bucket secret key: " SECRET_KEY
    echo "\n"
fi

oc create secret generic "dg-$INSTANCE_ID-configuration-secret" -n "$NAMESPACE" \
    --from-literal "aws_access_key=$ACCESS_KEY" \
    --from-literal "aws_secret_key=$SECRET_KEY"

sleep 180 
oc patch datagateinstanceservices dg$INSTANCE_ID -n cpd --type='merge' -p='{"spec": {"ignoreForMaintenance": true}}'
