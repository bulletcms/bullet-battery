#!/usr/bin/env bash

version="v1.2.1"

if ! [ -e "$PWD/rkt/rkt" ]; then
  wget "https://github.com/coreos/rkt/releases/download/$version/rkt-$version.tar.gz" -O rkt.tar.gz
  tar -xvzf rkt.tar.gz -C "$PWD/rkt" --strip-components=1
  rm rkt.tar.gz
fi
