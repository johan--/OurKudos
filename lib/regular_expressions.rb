module RegularExpressions

  def self.email
    /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end

  def self.password
    /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,}$/
  end

  def self.twitter
    /^@{1}/
  end

  def self.facebook_friend
    /^fb_{1}/
  end

  def self.protocol
    /^http(?:s?)\:\/\//
  end

  def self.merchant
    /^mrt_{1}/
  end

  def self.word
    /\S*/
  end

  def self.received_kudos_subject
    /sent you Kudos/
  end

  def self.email_username
    /^([^@\s]+)/i
  end

 #TODO place other reg exps here

end
