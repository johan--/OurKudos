module OurKudos
  module Lockable

    mattr_accessor :max_attempts
    
    @@max_attempts = 5

    def set_lock_time
      update_attribute :unlock_in,  Time.now - 100.years unless needs_lock?
      update_attribute :unlock_in,  Time.now + lock_seconds.seconds
    end

    def minutes_seconds
      return "#{blocked_for} seconds" if blocked_for < 60
      return "#{blocked_for/60} minutes" if blocked_for > 60
    end

    def lock_message
      "Your account has been locked for another #{minutes_seconds}"if needs_lock?
    end

    def lock_seconds
      return 3600 if failed_attempts > 99

      ary = []
      1.step(@@max_attempts*10,0.5) {|i| ary << i}

      (failed_attempts*2)*(ary[failed_attempts-@@max_attempts])
    end

    def blocked_for
      @blocked_for ||= lock_seconds
    end

    def needs_lock?
      self.failed_attempts > @@max_attempts
    end

    def is_locked?
      Time.now.utc < self.unlock_in.utc
    end

    def increase_attempt_count!
      update_attribute :failed_attempts, self.failed_attempts += 1
    end

    def after_sign_in_flow(password)
      unless valid_password? password
        increase_attempt_count!        
        set_lock_time if needs_lock?
        return true
      end
      return false
    end
   
  end
end

Warden::Manager.after_authentication :except => :fetch do |record, warden, options|
  request = warden.request
  if record.respond_to?(:after_sign_in_flow)
    if request[:user] && request[:user][:password] && warden.authenticated?
      unless record.after_sign_in_flow request[:user][:password]
      else
        warden.logout(options[:scope])
      end
    end
  end
end
