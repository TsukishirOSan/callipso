# Time-stamp: <2014-05-12 20:09:10 yonkeltron>
FROM debian:testing
MAINTAINER yonkeltron
# update stuff
RUN apt-get update --fix-missing
RUN apt-get install apt-utils --yes
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes

# install needed packages
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl procps libreadline6-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison pkg-config libffi-dev #supervisor

# install rvm and ruby
RUN curl -sSL https://get.rvm.io | bash -s stable
RUN /usr/local/rvm/bin/rvm-shell -l -c "rvm install 2.1.1 --fuzzy"
RUN /usr/local/rvm/bin/rvm-shell -l -c "rvm use 2.1.1 --default"
ADD gemrc /tmp/gemrc
RUN touch /etc/gemrc
RUN cat /tmp/gemrc >> /etc/gemrc

ADD config /sexbox
WORKDIR /sexbox
ADD Gemfile /sexbox/Gemfile
RUN /usr/local/rvm/bin/rvm-shell -l -c "bundle install"
#ADD config.rb /sexbox/config.rb
#RUN /usr/local/rvm/bin/rvm-shell -l -c "ruby config.rb"

# install fluentd
#RUN adduser --no-create-home --disabled-login --disabled-password --quiet --gecos "" fluentd
#RUN /usr/local/rvm/bin/rvm-shell -l -c "fluentd --setup ./fluent"
#RUN /usr/local/rvm/bin/rvm-shell -l -c "fluentd -c ./fluent/fluent.conf -vv &"

# clean up
RUN DEBIAN_FRONTEND=noninteractive apt-get clean --yes

# make logging directory
RUN mkdir -p /var/log/supervisor
# add supervisor config
#ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# GO TIME PARTY NOW
#CMD ["/usr/bin/supervisord"]

