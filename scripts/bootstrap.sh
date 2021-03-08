#!/bin/bash
if [ "$#" -ne 4 ]; then
  echo "Usage: $0 PUPPET_REPOSITORY HOSTNAME PUPPET_REPOSITORY_BRANCH PUPPET_MAJOR_VERSION"
  exit 1
fi

function colorecho() {
  COLORED="\e[44m"
  NC="\e[49m"
  echo -e "${COLORED}$@${NC}"
}

PUPPET_REPOSITORY=$1
HOSTNAME=$2
PUPPET_REPOSITORY_BRANCH=$3
PUPPET_MAJOR_VERSION=$4

colorecho "PUPPET_MAJOR_VERSION=$PUPPET_MAJOR_VERSION"
colorecho "PUPPET_REPOSITORY=$PUPPET_REPOSITORY"
colorecho "PUPPET_REPOSITORY_BRANCH=$PUPPET_REPOSITORY_BRANCH"
colorecho "HOSTNAME=$HOSTNAME"

#                         Puppet5 Puppet6 Puppet7
# Debian  8:    jessie       x       x
# Debian  9:    stretch      x       x       x
# Debian 10:    buster       x       x       x
# Ubuntu 14.04: trusty       x       x
# Ubuntu 16.04: xenial       x       x       x
# Ubuntu 18.04: bionic       x       x       x
# Ubuntu 20.04: focal                x       x
echo
colorecho "Loading distribution information:"
source /etc/os-release
DISTRIBUTION_ID=$ID
DISTRIBUTION_RELEASE=$VERSION_ID
DISTRIBUTION_CODENAME=$VERSION_CODENAME
DISTRIBUTION_DESCRIPTION=$PRETTY_NAME
if [[ "$DISTRIBUTION_ID" = "debian" && "$DISTRIBUTION_RELEASE" = "8" ]]; then
  # missing codename in jessie's /etc/os-release
  DISTRIBUTION_CODENAME="jessie"
fi
echo "This host is running $DISTRIBUTION_ID $DISTRIBUTION_RELEASE ($DISTRIBUTION_CODENAME) ($DISTRIBUTION_DESCRIPTION)"

echo
colorecho "Setting hostname to ${HOSTNAME}..."
hostname ${HOSTNAME}
echo ${HOSTNAME} > /etc/hostname
colorecho "Set hostname to ${HOSTNAME}"

echo
colorecho "Installing puppet apt repository..."
apt-key adv --fetch-keys http://apt.puppetlabs.com/DEB-GPG-KEY-puppet
curl -o /tmp/puppet.deb http://apt.puppetlabs.com/puppet${PUPPET_MAJOR_VERSION}-release-${DISTRIBUTION_CODENAME}.deb
dpkg -i /tmp/puppet.deb
RC=$?
colorecho "Installed puppet repository (return code: $RC)"

echo
colorecho "Updating apt..."
apt-get update
colorecho "Updated puppet (return code: $RC)"

echo
colorecho "Installing puppet..."
apt-get -y install git puppet-agent
RC=$?
colorecho "Installed puppet (return code: $RC)"

echo
colorecho "Installing r10k..."
/opt/puppetlabs/puppet/bin/gem install r10k --no-document
RC=$?
colorecho "Installed r10k (return code: $RC)"

echo
colorecho "Cloning puppet repository '${PUPPET_REPOSITORY}' on branch ${PUPPET_REPOSITORY_BRANCH}..."
cd /etc/puppetlabs/code/environments
mv production production.orig
git clone --branch ${PUPPET_REPOSITORY_BRANCH} ${PUPPET_REPOSITORY} production
cd production
colorecho "Cloned puppet repository '${PUPPET_REPOSITORY}' on branch ${PUPPET_REPOSITORY_BRANCH}"

exit
# TODO: the following this are basically run-puppet.sh
#       puppify.sh should call run-puppet.sh
#       then, a test Dockerfile can be built even with failing r10k and puppet apply

echo
colorecho "Installing Puppetfile dependencies..."
/opt/puppetlabs/puppet/bin/r10k puppetfile install --verbose=info
RC=$?
colorecho "Installed Puppetfile dependencies (return code: $RC)"

echo
colorecho "Applying puppet..."
/opt/puppetlabs/bin/puppet apply --environment=production /etc/puppetlabs/code/environments/production/manifests/
RC=$?
colorecho "Applied puppet (return code: $RC)"

exit $RC