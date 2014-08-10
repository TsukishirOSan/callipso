require 'spec_helper'

describe 'RVM' do
  describe command('rvm version') do
    it { should return_stdout(/\(stable\)/) }
  end

  describe command('rvm list') do
    it { should return_stdout(/2\.1\.2/) }
  end
end
