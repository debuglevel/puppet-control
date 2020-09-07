#!/bin/bash

if [ "$#" -lt 2 ]; then
  cat <<USAGE
Usage: $0 TARGETHOST HOSTNAME [BRANCH] [EXISTINGUSER]
Install Puppet on the node TARGETHOST (IP address or DNS name) and run 
the bootstrap process. Set the hostname to HOSTNAME, and optionally use 
the control repo branch BRANCH. Use EXISTINGUSER to connect via ssh.
USAGE
  exit 1
fi

PUPPET_REPO=https://github.com/debuglevel/puppet-control.git
IDENTITYFILE=""
#IDENTITYFILE="-i $HOME/.ssh/puppet.pem" # use this to use a custom private ssh key instead of ssh default

TARGETHOST=$1
HOSTNAME=${2}
BRANCH=${3:-production} # use "production" branch if none is provided
EXISTINGUSER=${4:-ubuntu} # user to connect via ssh; defaults to "ubuntu"

OPTIONS="-oStrictHostKeyChecking=no"

echo "Copying bootstrap script... "
scp ${IDENTITYFILE} ${OPTIONS} $(dirname $0)/bootstrap.sh ${EXISTINGUSER}@${TARGETHOST}:/tmp
echo "Copied bootstrap script"

echo "Bootstrapping... "
ssh -t ${IDENTITYFILE} ${OPTIONS} ${EXISTINGUSER}@${TARGETHOST} "sudo bash /tmp/bootstrap.sh ${PUPPET_REPO} ${HOSTNAME} ${BRANCH}"
echo "Bootstrapped"
