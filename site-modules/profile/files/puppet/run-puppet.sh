#!/bin/bash

# NOTE: "production" is just the name of directory where the git repository was cloned into
cd /etc/puppetlabs/code/environments/production

# update puppet control repo
git pull

# install dependencies
/opt/puppetlabs/puppet/bin/r10k puppetfile install

# apply puppet
/opt/puppetlabs/bin/puppet apply --environment production manifests/
