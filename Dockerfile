# Time-stamp: <2014-07-31 21:31:57 yonkeltron>
FROM debian:testing
MAINTAINER yonkeltron
# update stuff
RUN apt-get update #--fix-missing
#RUN apt-get install apt-utils --yes
#RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes

# install needed packages
#RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes build-essential libssl-dev libyaml-dev git libtool libxslt-dev libxml2-dev libpq-dev gawk curl procps libreadline6-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake bison pkg-config libffi-dev libgnutls26 #supervisor

# install rvm and ruby
#RUN ln -sf /proc/self/fd /dev/fd

ADD config /sexbox
WORKDIR /sexbox
ADD ansible/configuration-playbook.yml /sexbox/configuration-playbook.yml
RUN DEBIAN_FRONTEND=noninteractive apt-get install --yes --fix-missing apt-utils ansible aptitude
RUN echo localhost >> /etc/ansible/hosts
RUN ansible-playbook -v -c local configuration-playbook.yml


ADD Gemfile /sexbox/Gemfile

ADD gemrc /tmp/gemrc
RUN touch /etc/gemrc
RUN cat /tmp/gemrc >> /etc/gemrc
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
