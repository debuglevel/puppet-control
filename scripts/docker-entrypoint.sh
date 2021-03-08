#!/bin/bash
echo "== Running docker-entrypoint.sh ..."

echo "== rm -rf /etc/puppetlabs/code/environments/production/modules ..."
rm -rf /etc/puppetlabs/code/environments/production/modules

echo "== Running /tmp/run-puppet.sh ..."
/tmp/run-puppet.sh

bash