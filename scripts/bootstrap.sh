#!/bin/bash
if [ "$#" -ne 3 ]; then
  echo "Usage: $0 PUPPET_REPO HOSTNAME BRANCH"
  exit 1
fi

PUPPET_REPO=$1
HOSTNAME=$2
BRANCH=$3

echo "Setting hostname to ${HOSTNAME}..."
hostname ${HOSTNAME}
echo ${HOSTNAME} > /etc/hostname
echo "Set hostname to ${HOSTNAME}"

echo "Installing puppet..."
source /etc/lsb-release
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
wget http://apt.puppetlabs.com/puppetlabs-release-${DISTRIB_CODENAME}.deb
dpkg -i puppetlabs-release-${DISTRIB_CODENAME}.deb
apt-get update
apt-get -y install git puppet-agent
echo "Installed puppet"

echo "Cloning puppet repository '${PUPPET_REPO}'..."
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone ${PUPPET_REPO} production
cd production
git checkout ${BRANCH}
echo "Cloned puppet repository '${PUPPET_REPO}' and checked out branch ${BRANCH}"

echo "Installing r10k..."
/opt/puppetlabs/puppet/bin/gem install r10k --no-rdoc --no-ri
echo "Installed r10k"

echo "Installing Puppetfile dependencies..."
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose
echo "Installed Puppetfile dependencies"

echo "Applying puppet..."
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
echo "Applied puppet"
