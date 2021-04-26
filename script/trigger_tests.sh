#!/bin/sh

# Configuration File Path
#CONFIG_INFRA=config/app-config.json

#ACCOUNT=$(cat $CONFIG_INFRA | jq -r '.Project.Account') #ex> 123456789123
#REGION=$(cat $CONFIG_INFRA | jq -r '.Project.Region') #ex> us-east-1
#PROFILE_NAME=$(cat $CONFIG_INFRA | jq -r '.Project.Profile') #ex> cdk-demo
#PROJECT_NAME=$(cat $CONFIG_INFRA | jq -r '.Project.Name') #ex> TextClassification
#PROJECT_STAGE=$(cat $CONFIG_INFRA | jq -r '.Project.Stage') #ex> Dev
#PROJECT_PREFIX=$PROJECT_NAME$PROJECT_STAGE #ex> TextClassificationDev

#aws sns publish --topic-arn arn:aws:sns:"$REGION":"$ACCOUNT":"$PROJECT_PREFIX"-TestTrigger-Topic --profile $PROFILE_NAME --message file://script/input_data.json

API_ID=$(aws apigateway get-rest-apis --query "items[?name=='TextClassificationDemo-APIS'].id" --output text)
API_ENDPOINT="https://$API_ID.execute-api.$REGION.amazonaws.com/$PROJECT_STAGE/text"
echo ${API_ENDPOINT}

for var in 0 1 2 3
do
  SENTENCE=$(cat ./script/input_data.json | jq ."TestData[$var].request.sentence")
  echo ${SENTENCE}

  curl --header "Content-Type: application/json" --request POST \
  --data '{"sentence":"$SENTENCE"}' ${API_ENDPOINT}

  echo .
  echo .
done



