#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 PUPPET_REPO HOSTNAME BRANCH"
  exit 1
fi

PUPPET_REPO=$1
HOSTNAME=$2
BRANCH=$3

echo
echo "Setting hostname to ${HOSTNAME}..."
hostname ${HOSTNAME}
echo ${HOSTNAME} > /etc/hostname
echo "Set hostname to ${HOSTNAME}"

echo
echo "Installing puppet apt repository..."
source /etc/lsb-release
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
curl -o /tmp/puppet.deb http://apt.puppetlabs.com/puppet5-release-${DISTRIB_CODENAME}.deb
dpkg -i /tmp/puppet.deb
echo "Installed puppet repository..."

echo
echo "Installing puppet..."
apt-get update
apt-get -y install git puppet-agent
echo "Installed puppet"

echo
echo "Cloning puppet repository '${PUPPET_REPO}' on branch ${BRANCH}..."
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone --branch ${BRANCH} ${PUPPET_REPO} production
cd production
echo "Cloned puppet repository '${PUPPET_REPO}' on branch ${BRANCH}"

echo
echo "Installing r10k..."
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
echo "Installed r10k"

echo
echo "Installing Puppetfile dependencies..."
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
echo "Installed Puppetfile dependencies"

echo
echo "Applying puppet..."
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
echo "Applied puppet"
