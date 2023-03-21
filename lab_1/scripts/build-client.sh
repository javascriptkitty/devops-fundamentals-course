#!/usr/bin/env bash

PROJECT_DIR=$HOME/Documents/shop-angular-cloudfront
CLIENT_BUILD_DIR=$PROJECT_DIR/dist/static

clientBuildFile=$PROJECT_DIR/dist/client-app.zip

ENV_CONFIGURATION="development"

if [$1 != '']
 then
  if [[ $1 = "prod" || $1 = "production" ]]
  then
ENV_CONFIGURATION="production"
  fi
fi

cd $PROJECT_DIR && npm install
echo "Project dependencies are installed"

if [ -e "$clientBuildFile" ]; then
  rm "$clientBuildFile"
  echo "$clientBuildFile was removed."
fi

ng build --configuration=$ENV_CONFIGURATION --output-path=$CLIENT_BUILD_DIR

zip -r $clientBuildFile $CLIENT_BUILD_DIR

echo "Client app was built with $ENV_CONFIGURATION configuration."
