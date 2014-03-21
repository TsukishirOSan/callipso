# Time-stamp: <2014-03-21 09:51:35 yonkeltron>
FROM debian:jessie
MAINTAINER yonkeltron
# update stuff
RUN apt-get update --fix-missing
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes

# install needed packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl procps libreadline6-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison pkg-config libffi-dev supervisor

# install rvm and ruby
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm-shell -l -c "rvm install 2.1.1 --fuzzy"
RUN /usr/local/rvm/bin/rvm-shell -l -c "rvm use 2.1.1 --default"
ADD gemrc /tmp/gemrc
RUN touch /etc/gemrc
RUN cat /tmp/gemrc >> /etc/gemrc

# install fluentd
RUN /usr/local/rvm/bin/rvm-shell -l -c "gem install fluentd --no-document"
RUN adduser --no-create-home --disabled-login --disabled-password --quiet fluentd
#RUN /usr/local/rvm/bin/rvm-shell -l -c "fluentd --setup ./fluent"
#RUN /usr/local/rvm/bin/rvm-shell -l -c "fluentd -c ./fluent/fluent.conf -vv &"

# clean up
RUN DEBIAN_FRONTEND=noninteractive apt-get clean --yes

# make logging directory
RUN mkdir -p /var/log/supervisor
# add supervisor config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# GO TIME PARTY NOW
CMD ["/usr/bin/supervisord"]

