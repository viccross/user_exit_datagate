#!/bin/bash
oc get deployments -n cpd | grep 'dg-.*-data-gate-iceberg-server' | awk '{print $1}' | while read deployment; do oc get deployment -n cpd "$deployment" -o yaml > "icebergserver-deployment.yaml"; done


sleep 5

sed -i '/args:/a\        - -cp\n        - /opt/ibm/dwa/bin/tundra-iceberg/iceberg-server-2.0.0.jar:/opt/ibm/dwa/libs/tundra-lt-iceberg/hive-iceberg-shading-4.0.0.jar:/opt/ibm/dwa/libs/tundra-lt-iceberg/*\n        - -Dlog4j2.configurationFile=/opt/ibm/dwa/bin/tundra-iceberg/log4j2.xml\n        - com.ibm.iceberg.server.IcebergServer' icebergserver-deployment.yaml


sleep 5
sed -i '/- ca.crt/a\        command:\n        - java        ' icebergserver-deployment.yaml

sleep 5
oc apply -f icebergserver-deployment.yaml -n cpd
