#!/bin/bash

rm -rf /etc/puppetlabs/code/environments/production/modules
/tmp/run-puppet.sh
bash