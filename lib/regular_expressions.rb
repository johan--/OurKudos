module RegularExpressions

  def self.email
    /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  end

  def self.password
    /^(?=.*\d)(?=.*([a-z]|[A-Z]))([\x20-\x7E]){6,}$/
  end
 #TODO place other reg exps here

end
