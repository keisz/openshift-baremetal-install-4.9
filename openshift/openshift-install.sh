#!/usr/bin/env bash

## ignition creation prep
rm -rf bare-metal/
mkdir -p bare-metal
cp install-config.yaml bare-metal/

## create manifest
openshift-install create manifests --dir=bare-metal

# ensure masters are not schedulable
if [[ `uname` == 'Linux' ]] ; then 
sed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' bare-metal/manifests/cluster-scheduler-02-config.yml
else 
# macos sed will fail, this script requires `brew install gnu-sed`
gsed -i 's/mastersSchedulable: true/mastersSchedulable: false/g' bare-metal/manifests/cluster-scheduler-02-config.yml
fi

# create iginition file
openshift-install create ignition-configs --dir=bare-metal

# copy ignition file
chmod +r bare-metal/*.ign
cp -r bare-metal/*.ign ../docker/nginx/

