module OurKudos
  module Lockable

    mattr_accessor :max_attempts
    attr_accessor  :lock_message
    
    @@max_attempts = 5

    def set_lock_time
      update_attribute :unlock_in,  Time.now + lock_seconds.seconds
    end

    def unlock!
      self.unlock_in = Time.now - 100.years
      self.failed_attempts = 0
      self.save :validate => false
    end

    def minutes_seconds
      return "#{blocked_for} seconds" if blocked_for < 60
      return "#{blocked_for/60} minutes" if blocked_for > 60
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

    def allowed_attempts_exceeded?
      self.failed_attempts > @@max_attempts
    end

    def is_locked?
      allowed_attempts_exceeded?  && !lock_time_expired?
    end

    def lock_time_expired?
      Time.now.utc > self.unlock_in.utc
    end

    def same_ip?(request)
      last_sign_in_ip == request.ip
    end

    def increase_attempt_count!
      update_attribute :failed_attempts, self.failed_attempts += 1
    end

    def session_is_valid
      if lock_time_expired?
        unlock!
        self.lock_message = ''
        return false
      else
        self.lock_message =  I18n.t('devise.sessions.user.locked_until', :time => self.unlock_in.strftime("%I:%M:%S"))
        return true
      end
    end

    def session_is_invalid
      increase_attempt_count!
      if allowed_attempts_exceeded?
        set_lock_time 
        self.lock_message  = I18n.t('devise.sessions.user.locked', :time => minutes_seconds)
      else
        self.lock_message = I18n.t('devise.sessions.user.invalid')
      end
      return true
    end

    def after_sign_in_flow password
      unless valid_password? password
        session_is_invalid
      else
        session_is_valid
      end
    end

    def oauth_after_sign_in_flow
      return session_is_invalid if is_locked?
      return session_is_valid   unless is_locked?
    end

   
  end
end

Warden::Manager.after_authentication :except => :fetch do |record, warden, options|

  request = warden.request
  scope   = options[:scope]

  if record.respond_to?(:after_sign_in_flow)
    if warden.authenticated?
    
      if request[:user] && request[:user][:password] &&  request.params[:commit] != "Sign up"

        if record.after_sign_in_flow(request[:user][:password]) && record.same_ip?(request)
          warden.logout scope
          throw :warden, :scope => scope, :message => record.lock_message
        else #password is correct
          if record.is_locked?
            throw :warden, :scope => scope, :message => record.lock_message
            warden.logout scope
          end
        end

      elsif request.env.keys.include? "omniauth.auth"

        if record.oauth_after_sign_in_flow
          warden.logout scope
          throw :warden, :scope => scope, :message => record.lock_message
        end

      end
    end
  end

end