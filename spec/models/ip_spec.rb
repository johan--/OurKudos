require 'spec_helper'

describe Ip do
  context 'given an instance' do
    let(:ip)        { Factory(:ip)        }
    let(:locked_ip) { Factory(:locked_ip) }

    it 'should lock given ip address if failed attempts are greater than given numer (i.e. 5)' do
      ip.failed_attempts = 10
      ip.set_lock_time
      ip.unlock_in.should > Time.now
      ip.is_locked?.should be_true
    end

  end
end
