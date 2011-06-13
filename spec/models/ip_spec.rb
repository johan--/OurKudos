require 'spec_helper'

describe Ip do
  context 'an instance' do
    let(:ip)        { Factory(:ip)        }
    let(:locked_ip) { Factory(:locked_ip) }

    it 'should lock given ip address if failed attempts are greater than given numer (i.e. 5)' do
      ip.failed_attempts = 10
      ip.set_lock_time
      ip.unlock_in.should > Time.now
      ip.is_locked?.should be_true
    end

    it 'should be able to unlock itself' do
      locked_ip.should respond_to 'unlock!'

      locked_ip.failed_attempts.should_not == 0
      locked_ip.unlock_in > Time.now

      locked_ip.unlock!

      locked_ip.failed_attempts.should == 0
      locked_ip.unlock_in < Time.now

    end

    it 'should display time in minutes if it is locked for more than minute' do
      time = locked_ip.lock_seconds
        debugger
        (locked_ip.minutes_seconds.include?((time/60).to_s).should be_true) &&
          (locked_ip.minutes_seconds.include?("minutes").should be_true)
    end
 
    it 'should display time in seconds if ip is locked for less than 60 sec' do
      time = ip.lock_seconds

      (ip.minutes_seconds.include?(time.to_s).should be_true) &&
        (ip.minutes_seconds.include?("seconds").should be_true)
    end

    it 'should return lock time for given address' do
      ip.should respond_to "lock_seconds"

      ip.lock_seconds.should == 0
      locked_ip.lock_seconds.should_not == 0
    end

    it 'should know if it exceeded attempts for given address' do
      ip.should respond_to 'allowed_attempts_exceeded?'

      ip.allowed_attempts_exceeded?.should be_false

      locked_ip.allowed_attempts_exceeded?.should be_true
    end

    it 'should know if is locked' do
      ip.should respond_to "is_locked?"

      ip.allowed_attempts_exceeded?.should be_false
      ip.unlock_in > Time.now
      ip.is_locked?.should be_false

      locked_ip.allowed_attempts_exceeded?.should be_true
      locked_ip.unlock_in < Time.now
      locked_ip.is_locked?.should be_true

      ip.blocked = true
      ip.is_locked?.should be_true

    end

    it 'should know if lock time expired' do
      ip.should respond_to 'lock_time_expired?'

      ip.lock_time_expired?.should be_true

      locked_ip.lock_time_expired?.should be_false
    end

    it 'should be able to remember failed login attempts' do
      ip.should respond_to 'increase_attempt_count!'

      before = ip.failed_attempts

      ip.increase_attempt_count!

      after  = ip.failed_attempts

      (before + 1).should == after
    end
    
  end
end
