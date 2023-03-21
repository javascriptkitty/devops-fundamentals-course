#!/usr/bin/env bash

PROJECT_DIR=$HOME/Documents/shop-angular-cloudfront

cd $PROJECT_DIR

npm audit
npm run lint
npm run test
npm run e2e
