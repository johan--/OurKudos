CURRENT_EMAIL = 'notifications@ourkudos.com'
require 'mailman'

Mailman.config.rails_root = File.expand_path("./../../")
Mailman.config.pop3 = {
  :username => CURRENT_EMAIL,
  :password => 'ba1tarm0hawk',
  :server   => 'pop.gmail.com',
  :port     => 995,
  :ssl      => true
}
Mailman::Application.run do
  from(CURRENT_EMAIL).subject(RegularExpressions.received_kudos_subject) do |kudo_id|

  end
end