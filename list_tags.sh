#!/bin/bash
# NEXUS_CREDS='nexususer:password'
IMAGE_NAME='image_name'
CONT_TOKEN_VALUE=''
CONT_TOKEN_TITLE='&continuationToken'
CONT_TOKEN=''
CURL_CMD="curl -s -u ${NEXUS_CREDS} \
    -X GET https://nexus.cloud/service/rest/v1/search?repository=dev&format=docker&name=${IMAGE_NAME}"

echo $CURL_CMD
while :
do
  if [ "${CONT_TOKEN_VALUE}" == "null" ]; then break; fi
  if [ "${CONT_TOKEN_VALUE}" != '' ]; then CONT_TOKEN="$CONT_TOKEN_TITLE=$CONT_TOKEN_VALUE"; else CONT_TOKEN=""; fi
  CURL_RESULT=`${CURL_CMD}${CONT_TOKEN}`
  CONT_TOKEN_VALUE=`echo "${CURL_RESULT}" | jq '.continuationToken' | sed -e 's/"//g'`
  #echo "${CONT_TOKEN_VALUE}"
  TAGS=`echo "${CURL_RESULT}" | jq '.items[] | "\(.name) \(.version)"' | sed -e 's/ /:/'`
  for t in ${TAGS}; do echo ${t}; done
done
