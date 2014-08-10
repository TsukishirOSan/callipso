require 'spec_helper'

describe 'Security' do
  describe selinux do
    it { should be_disabled }
  end
end
