require 'spec_helper'

describe 'Util packages' do
  describe package('git') do
    it { should be_installed }
  end

  describe package('gawk') do
    it { should be_installed }
  end
end
