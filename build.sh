#!/usr/bin/env bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "This script uses functionality which requires root privileges"
  exit 1
fi

version="v0.2.2"

# installs acbuild
if ! [ -e "$PWD/build_modules/acbuild" ]; then
  wget https://github.com/appc/acbuild/releases/download/$version/acbuild.tar.gz && tar -xvzf acbuild.tar.gz -C "$PWD/build_modules" && rm acbuild.tar.gz
fi


# Start the build with an empty ACI
./build_modules/acbuild --debug begin

# In the event of the script exiting, end the build
acbuildEnd() {
  export EXIT=$?
  ./build_modules/acbuild --debug end && exit $EXIT
}
trap acbuildEnd EXIT


# Name the ACI
./build_modules/acbuild --debug set-name xorkevin/bullet-battery

# Version info
./build_modules/acbuild label add version 0.1.0
./build_modules/acbuild label add arch amd64
./build_modules/acbuild label add os linux
./build_modules/acbuild annotation add authors "xorkevin <wangkevin448@gmail.com>"


# Based on alpine
./build_modules/acbuild --debug dep add quay.io/coreos/alpine-sh

# Install nginx
./build_modules/acbuild --debug run -- apk update
./build_modules/acbuild --debug run -- apk add nginx

# Add a port for http traffic over port 80
./build_modules/acbuild --debug port add http tcp 80

# Add a mount point for files to serve
./build_modules/acbuild --debug mount add html /usr/share/nginx/html

# Run nginx in the foreground
./build_modules/acbuild --debug set-exec -- /usr/sbin/nginx -g "daemon off;"


# Save the ACI
./build_modules/acbuild --debug write --overwrite bullet-battery.aci
