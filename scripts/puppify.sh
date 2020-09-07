#!/bin/bash

if [ "$#" -lt 2 ]; then
  cat <<USAGE
Usage: $0 TARGETHOST HOSTNAME [BRANCH]
Install Puppet on the node TARGETHOST (IP address or DNS name) and run 
the bootstrap process. Set the hostname to HOSTNAME, and optionally use 
the control repo branch BRANCH.
USAGE
  exit 1
fi

PUPPET_REPO=https://github.com/debuglevel/puppet-control.git
IDENTITYFILE="-i $HOME/.ssh/puppet.pem"

TARGETHOST=$1
HOSTNAME=${2}
BRANCH=${3:-production} # use "production" branch if none is provided

OPTIONS="-oStrictHostKeyChecking=no"

echo -n "Copying bootstrap script... "
scp ${IDENTITYFILE} ${OPTIONS} $(dirname $0)/bootstrap.sh ubuntu@${TARGETHOST}:/tmp
echo "done."

echo -n "Bootstrapping... "
ssh ${IDENTITYFILE} ${OPTIONS} ubuntu@${TARGETHOST} "sudo bash /tmp/bootstrap.sh ${PUPPET_REPO} ${HOSTNAME} ${BRANCH}"
echo "done."
