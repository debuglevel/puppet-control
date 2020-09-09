#!/bin/bash
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 PUPPET_REPO HOSTNAME BRANCH PUPPET_MAJOR_VERSION"
  exit 1
fi
COLORED="\e[44m"
NC="\e[49m"

PUPPET_REPO=$1
HOSTNAME=$2
BRANCH=$3
PUPPET_VERSION=$4

echo
echo -e "${COLORED}Loading distribution information:${NC}"
source /etc/os-release
DISTRIB_ID=$ID
DISTRIB_RELEASE=$VERSION_ID
DISTRIB_CODENAME=$VERSION_CODENAME
DISTRIB_DESCRIPTION=$PRETTY_NAME
if [[ "$DISTRIB_ID" -eq "debian" && "$DISTRIB_RELEASE" -eq "8" ]]; then
  # missing codename in jessie /etc/os-release
  DISTRIB_CODENAME="jessie"
fi
echo "This host is running $DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_CODENAME) ($DISTRIB_DESCRIPTION)"

echo
echo -e "${COLORED}Setting hostname to ${HOSTNAME}...${NC}"
hostname ${HOSTNAME}
echo ${HOSTNAME} > /etc/hostname
echo -e "${COLORED}Set hostname to ${HOSTNAME}${NC}"

echo
echo -e "${COLORED}Installing puppet apt repository...${NC}"
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
curl -o /tmp/puppet.deb http://apt.puppetlabs.com/puppet${PUPPET_VERSION}-release-${DISTRIB_CODENAME}.deb
dpkg -i /tmp/puppet.deb
RC=$?
echo -e "${COLORED}Installed puppet repository (return code: $RC)${NC}"

echo
echo -e "${COLORED}Updating apt...${NC}"
apt-get update
echo -e "${COLORED}Updated puppet (return code: $RC)${NC}"

echo
echo -e "${COLORED}Installing puppet...${NC}"
apt-get -y install git puppet-agent
RC=$?
echo -e "${COLORED}Installed puppet (return code: $RC)${NC}"

echo
echo -e "${COLORED}Installing r10k...${NC}"
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
RC=$?
echo -e "${COLORED}Installed r10k (return code: $RC)${NC}"

echo
echo -e "${COLORED}Cloning puppet repository '${PUPPET_REPO}' on branch ${BRANCH}...${NC}"
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone --branch ${BRANCH} ${PUPPET_REPO} production
cd production
echo -e "${COLORED}Cloned puppet repository '${PUPPET_REPO}' on branch ${BRANCH}${NC}"

exit
# TODO: the following this are basically run-puppet.sh
#       puppify.sh should call run-puppet.sh
#       then, a test Dockerfile can be built even with failing r10k and puppet apply

echo
echo -e "${COLORED}Installing Puppetfile dependencies...${NC}"
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
RC=$?
echo -e "${COLORED}Installed Puppetfile dependencies (return code: $RC)${NC}"

echo
echo -e "${COLORED}Applying puppet...${NC}"
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
RC=$?
echo -e "${COLORED}Applied puppet (return code: $RC)${NC}"

exit $RC