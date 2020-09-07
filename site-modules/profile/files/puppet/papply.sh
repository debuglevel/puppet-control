#!/bin/bash

# TODO: this file is seems not to be used

environment=${PUPPET_ENV:-production}

cd /etc/puppetlabs/code/environments/${environment}

# install dependencies
/opt/puppetlabs/puppet/bin/r10k puppetfile install

# apply puppet
/opt/puppetlabs/bin/puppet apply --environment ${environment} --strict=warning /etc/puppetlabs/code/environments/${environment}/manifests/ $*
