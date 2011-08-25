CURRENT_EMAIL = 'notifications@ourkudos.com'
require 'mailman'

Mailman.config.pop3 = {
  :username => CURRENT_EMAIL,
  :password => 'ba1tarm0hawk',
  :server   => 'pop.gmail.com',
  :port     => 995,
  :ssl      => true
}
Mailman::Application.run do
  from(CURRENT_EMAIL).subject(/sent you Kudos/) do |kudo_id|

  end
end