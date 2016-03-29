#!/usr/bin/env bash

token=$(curl https://discovery.etcd.io/new?size=3)

echo $token

find='etcd_token'

IFS='%'

while read a ; do echo ${a//$find/$token} ; done < ./run/user-data.template > ./run_config/user-data

cp ./run/config.rb.template ./run_config/config.rb

cp ./run/Vagrantfile ./run_config/Vagrantfile

unset IFS
