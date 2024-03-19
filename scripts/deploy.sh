#!/bin/bash
set -ev

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# deploy on aws
if [ "${TRAVIS_BRANCH}" = "main" ]; then
  if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
    # master - deploy to production
    echo deploy to production

    STACK_NAME=htmlToPdfservice
  	ENV_SUFFIX=
  else
    # pull request based on master - deploy to sys
    echo deploy to sys
    STACK_NAME=htmlToPdfservice-sys
    ENV_SUFFIX=-sys
  fi
    # deploy the service to amazon
    aws cloudformation deploy --stack-name $STACK_NAME --no-fail-on-empty-changeset --template-file ./aws/application.yml --parameter-overrides rootPath=/pdf-service/ environmentSuffix=$ENV_SUFFIX --capabilities=CAPABILITY_IAM
fi

echo "deploy complete "
