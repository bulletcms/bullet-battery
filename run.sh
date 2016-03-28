#!/usr/bin/env bash

token=$(curl https://discovery.etcd.io/new?size=3)

echo $token

find='$token'

cat ./run/user-data.template | sed -e s/$find/$token/ > test

# sed -e s/\$token/$token/ ./run/user-data.template  > test
