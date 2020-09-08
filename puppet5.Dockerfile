FROM ubuntu:18.04
RUN apt-get update && apt-get install -y curl gnupg2
COPY scripts/bootstrap.sh /tmp
RUN /tmp/bootstrap.sh https://github.com/debuglevel/puppet-control.git puppet5test production

CMD bash