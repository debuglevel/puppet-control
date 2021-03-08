#!/bin/bash

# NOTE: "production" is just the name of directory where the git repository was cloned into
cd /etc/puppetlabs/code/environments/production

# update puppet control repository
echo "== git pull..."
git pull
echo "== git pull. done"

# install dependencies
echo "== r10k puppetfile install..."
/opt/puppetlabs/puppet/bin/r10k puppetfile install
echo "== r10k puppetfile install. done"

# apply puppet
echo "== puppet apply..."
/opt/puppetlabs/bin/puppet apply --environment production manifests/
echo "== puppet apply. done"
