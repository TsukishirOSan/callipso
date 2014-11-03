require 'spec_helper'

describe 'Development Dependencies' do
  describe package('build-essential') do
    it { should be_installed }
  end

  [
    'autoconf',
    'automake',
    'bison',
    'build-essential',
    'curl',
    'libffi-dev',
    'libgdbm-dev',
    'libgnutls-deb0-28',
    'libncurses5-dev',
    'libpq-dev',
    'libreadline6-dev',
    'libsqlite3-dev',
    'libssl-dev',
    'libtool',
    'libxml2-dev',
    'libxslt1-dev',
    'libyaml-dev',
    'pkg-config',
    'python-selinux',
    'procps',
    'sqlite3'
  ].each do |package_name|
    describe package(package_name) do
      it { should be_installed }
    end
  end
end
