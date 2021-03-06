FROM debian:10
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release
COPY scripts/bootstrap.sh /tmp
RUN /tmp/bootstrap.sh https://github.com/debuglevel/puppet-control.git puppet7test production 7
COPY site-modules/profile/files/puppet/run-puppet.sh /tmp/run-puppet.sh
COPY scripts/docker-entrypoint.sh /tmp

CMD /tmp/docker-entrypoint.sh