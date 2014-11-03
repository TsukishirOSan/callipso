require 'spec_helper'

describe 'RVM' do
  describe command('rvm version') do
    its(:stdout) { should match(/\(latest\)/) }
  end

  describe command('rvm list') do
    its(:stdout) { should match(/2\.1\.4/) }
  end
end
