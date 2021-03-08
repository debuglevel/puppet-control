# Puppify and bootstrap

To bootstrap a server, you need:

- IP address or DNS name of the target server
- a hostname which the server should be identified with
- git puppet repository branch (usually `production`)
- an existing user (the one you defined at installation, was already imaged with (`pi` for Raspbian) or whatever `cloud-init` or something the like created)
- the puppet version you would like to use (5 or 6; is rather a development feature than a real thing)

## Puppify

Puppyfing and bootstrapping a target host goes like this:

```
scripts/puppify.sh TARGET_SERVER HOSTNAME         [BRANCH]   [EXISTINGUSER] [PUPPET_VERSION]
scripts/puppify.sh 192.168.0.1   cat.petstore.org
scripts/puppify.sh 192.168.0.1   cat.petstore.org production ubuntu         6
```

`puppify.sh` copies the `bootstrap.sh` to the target host and runs it there.

## Boostrap

During bootstrap, puppet is installed. Ubuntu 16.04, 18.04, 20.04 and Debian 8, 9, 10 (and hopefully correspoding Rasbian distributions) are supported.

# Origin

This repository is a fork of [Puppet Beginner's Guide, Third Edition](https://github.com/bitfield/control-repo-3) which is based on [a skeleton Puppet control repo available from the Puppet GitHub account](https://github.com/puppetlabs/control-repo).

Further snippets may be found at [Puppet Beginner's Guide example repo](https://github.com/bitfield/puppet-beginners-guide-3).

# Cheat sheet

Run `puppet-lint` via docker:

```
docker run -ti --rm -v ${PWD}:/repo puppet/puppet-dev-tools:4.x puppet-lint /repo
```

Run testing docker image:

```
docker build -f puppet6ubuntu20.Dockerfile -t puppet6ubuntu20 .
# this removes modules directory
docker run -ti --rm -v ${PWD}:/etc/puppetlabs/code/environments/production puppet7ubuntu20
# this does not remove modules directory
docker run -ti --rm -v ${PWD}:/etc/puppetlabs/code/environments/production puppet7ubuntu20 /tmp/run-puppet.sh
```
