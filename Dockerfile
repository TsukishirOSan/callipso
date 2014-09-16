# Time-stamp: <2014-09-16 15:24:48 yonkeltron>
FROM debian:testing
MAINTAINER yonkeltron

# install rvm and ruby
#RUN ln -sf /proc/self/fd /dev/fd

ADD config /gadgetbox
WORKDIR /gadgetbox
ADD ansible/configuration-playbook.yml /gadgetbox/configuration-playbook.yml
# update stuff
RUN apt-get update #--fix-missing
#RUN apt-get install apt-utils --yes

# install needed packages
#RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl procps libreadline6-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison pkg-config libffi-dev libgnutls26 #supervisor

RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --fix-missing apt-utils ansible aptitude etckeeper
RUN echo localhost >> /etc/ansible/hosts
RUN ansible-playbook -c local configuration-playbook.yml


ADD Gemfile /gadgetbox/Gemfile

ADD gemrc /tmp/gemrc
RUN touch /etc/gemrc
RUN cat /tmp/gemrc >> /etc/gemrc

# clean up
RUN DEBIAN_FRONTEND=noninteractive apt-get clean --yes

# make logging directory
RUN mkdir -p /var/log/supervisor
# add supervisor config
#ADD config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN /usr/local/rvm/bin/rvm-shell -l -c "bundle install"
ADD Rakefile /gadgetbox/Rakefile
ADD rspec /gadgetbox/.rspec
ADD spec /gadgetbox/spec
RUN /usr/local/rvm/bin/rvm-shell -l -c "bundle exec rake spec"
