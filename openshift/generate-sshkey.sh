#!/bin/sh

## ignition creation prep
rm -rf sshkey/
mkdir -p sshkey
ssh-keygen -t ecdsa -b 384 -N ""  -C "OpenShift-install" -f sshkey/ocp-key

chmod 500 sshkey/ocp-key
