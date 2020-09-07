#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 PUPPET_REPO HOSTNAME BRANCH"
  exit 1
fi
COLORED="\e[44m"
NC="\e[49m"

PUPPET_REPO=$1
HOSTNAME=$2
BRANCH=$3

echo
echo -e "${COLORED}Loading distribution information:${NC}"
source /etc/lsb-release
echo "This host is running $DISTRIB_ID $DISTRIB_RELEASE ($DISTRIB_CODENAME) ($DISTRIB_DESCRIPTION)"

echo
echo -e "${COLORED}Setting hostname to ${HOSTNAME}...${NC}"
hostname ${HOSTNAME}
echo ${HOSTNAME} > /etc/hostname
echo -e "${COLORED}Set hostname to ${HOSTNAME}${NC}"

echo
echo -e "${COLORED}Installing puppet apt repository...${NC}"
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
curl -o /tmp/puppet.deb http://apt.puppetlabs.com/puppet5-release-${DISTRIB_CODENAME}.deb
dpkg -i /tmp/puppet.deb
echo -e "${COLORED}Installed puppet repository...${NC}"

echo
echo -e "${COLORED}Installing puppet...${NC}"
apt-get update
apt-get -y install git puppet-agent
echo -e "${COLORED}Installed puppet${NC}"

echo
echo -e "${COLORED}Cloning puppet repository '${PUPPET_REPO}' on branch ${BRANCH}...${NC}"
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone --branch ${BRANCH} ${PUPPET_REPO} production
cd production
echo -e "${COLORED}Cloned puppet repository '${PUPPET_REPO}' on branch ${BRANCH}${NC}"

echo
echo -e "${COLORED}Installing r10k...${NC}"
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
echo -e "${COLORED}Installed r10k${NC}"

echo
echo -e "${COLORED}Installing Puppetfile dependencies...${NC}"
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
echo -e "${COLORED}Installed Puppetfile dependencies${NC}"

echo
echo -e "${COLORED}Applying puppet...${NC}"
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
echo -e "${COLORED}Applied puppet${NC}"
