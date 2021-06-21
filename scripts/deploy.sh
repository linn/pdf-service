#!/bin/bash
set -ev

# install aws cli
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws
export PATH=~/bin:$PATH

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
    aws cloudformation deploy --stack-name $STACK_NAME --template-file ./aws/application.yml --parameter-overrides environmentSuffix=$ENV_SUFFIX --capabilities=CAPABILITY_IAM rootPath=/pdf-service/
fi

echo "deploy complete"
