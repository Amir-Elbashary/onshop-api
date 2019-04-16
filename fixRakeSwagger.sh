#!/bin/bash -

set -o nounset                              # Treat unset variables as an error


sed 's/"basePath": "",/"basePath": "\/",/' public/api-docs.json > public/api-docs-tmp.json;
mv public/api-docs-tmp.json public/api-docs.json;

FILES=public/api/v1/*
for i in $FILES
do
  sed 's/"basePath": "",/"basePath": "\/",/' $i > $i-tmp;
  mv $i-tmp  $i;
done
