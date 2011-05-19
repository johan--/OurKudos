class Ip < ActiveRecord::Base

  attr_accessor :lock_message
  cattr_accessor :max_attempts

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
    return 0    if failed_attempts < @@max_attempts

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
    blocked? || (allowed_attempts_exceeded?  && !lock_time_expired?)
  end

  def lock_time_expired?
    Time.now.utc > self.unlock_in.utc
  end

  def increase_attempt_count!
    update_attribute :failed_attempts, self.failed_attempts += 1
  end
  
  def session_is_valid
    if lock_time_expired?
      unlock!
      self.lock_message = ''
      return :ok
    else
      self.lock_message =  I18n.t('devise.sessions.user.locked_until',
                                  :time => self.unlock_in.strftime("%I:%M:%S"))
      return :not_expired
    end
  end

  def session_is_invalid
   increase_attempt_count!
   if allowed_attempts_exceeded?
      set_lock_time
      self.lock_message   = I18n.t('devise.sessions.user.locked', :time => minutes_seconds)
    else
      self.lock_message   = I18n.t('devise.sessions.user.invalid')
    end
    return :invalid
  end

  def check_for user, password
    if user.valid_password? password
      session_is_valid
    else
      session_is_invalid
    end
  end

  class << self

    def create_or_initialize_with request
      ip = Ip.find_or_initialize_by_address request.ip
      ip.last_seen = Time.now
      ip.save :validate => false
      ip
    end

  end



end
