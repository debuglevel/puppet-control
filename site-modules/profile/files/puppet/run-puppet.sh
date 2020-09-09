#!/bin/bash

# NOTE: "production" is just the name of directory where the git repository was cloned into
cd /etc/puppetlabs/code/environments/production

# update puppet control repo
echo "git pull..."
git pull

# install dependencies
echo "r10k puppetfile install..."
/opt/puppetlabs/puppet/bin/r10k puppetfile install

# apply puppet
echo "puppet apply..."
/opt/puppetlabs/bin/puppet apply --environment production manifests/
