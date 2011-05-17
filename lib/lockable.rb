module OurKudos
  module Lockable
    
    mattr_accessor :max_attempts
    
    @@max_attempts = 5

    def set_lock_time
      return self.unlock_in = Date.today-100.years if self.failed_attempts == 0 || self.failed_attempts < @@max_attempts
      self.unlock_in = Time.now + lock_seconds
    end

    def lock_seconds
      ary = []
      1.step(@@max_attempts*10,0.5) {|i| ary << i}

      return (self.failed_attempts*2)*(ary[self.failed_attempts-@@max_attempts])
    end

  end
end