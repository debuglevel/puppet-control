FROM debian:9
RUN apt-get update && apt-get install -y curl gnupg2 lsb-release
COPY scripts/bootstrap.sh /tmp
RUN /tmp/bootstrap.sh https://github.com/debuglevel/puppet-control.git puppet6test production 6
COPY site-modules/profile/files/puppet/run-puppet.sh /tmp/run-puppet.sh
COPY scripts/docker-entrypoint.sh /tmp

CMD /tmp/docker-entrypoint.sh