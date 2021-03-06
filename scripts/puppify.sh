#!/bin/bash

if [ "$#" -lt 2 ]; then
  cat <<USAGE
Usage: $0 TARGETHOST HOSTNAME [BRANCH] [EXISTINGUSER] [PUPPET_VERSION]
Install Puppet on the node TARGETHOST (IP address or DNS name) and run 
the bootstrap process. Set the hostname to HOSTNAME, and optionally use 
the control repo branch BRANCH. Use EXISTINGUSER to connect via ssh.
Use PUPPET_VERSION (5, 6) do define puppet version.
USAGE
  exit 1
fi
COLORED="\e[44m"
NC="\e[49m"

PUPPET_REPO=https://github.com/debuglevel/puppet-control.git
IDENTITYFILE=""
#IDENTITYFILE="-i $HOME/.ssh/puppet.pem" # use this to use a custom private ssh key instead of ssh default

TARGETHOST=$1
HOSTNAME=${2}
BRANCH=${3:-production} # use "production" branch if none is provided
EXISTINGUSER=${4:-ubuntu} # user to connect via ssh; defaults to "ubuntu"
PUPPET_VERSION=${5:-5} # user to connect via ssh; defaults to "ubuntu"

OPTIONS="-oStrictHostKeyChecking=no"

echo -e "${COLORED}Copying bootstrap script...${NC}"
scp ${IDENTITYFILE} ${OPTIONS} $(dirname $0)/bootstrap.sh ${EXISTINGUSER}@${TARGETHOST}:/tmp
echo -e "${COLORED}Copied bootstrap script${NC}"

echo
echo -e "${COLORED}Bootstrapping...${NC}"
ssh -t ${IDENTITYFILE} ${OPTIONS} ${EXISTINGUSER}@${TARGETHOST} "sudo bash /tmp/bootstrap.sh ${PUPPET_REPO} ${HOSTNAME} ${BRANCH} ${PUPPET_VERSION}"
echo -e "${COLORED}Bootstrapped${NC}"
