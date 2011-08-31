CURRENT_EMAIL = 'notifications@ourkudos.com'
require 'mailman'

ENV["RAILS_ENV"] ||= "staging"

require File.expand_path('../../../config/environment', __FILE__)


Mailman.config.poll_interval = 0
Mailman.config.ignore_stdin  = true


Mailman.config.logger = Logger.new(File.new(File.expand_path('../../../log/mailman.log', __FILE__),'w+'))

Mailman.config.pop3 = {
  :username => CURRENT_EMAIL,
  :password => 'ba1tarm0hawk',
  :server   => 'pop.gmail.com',
  :port     => 995,
  :ssl      => true
}

while true          #infinite loop
  Mailman::Application.run do
    to CURRENT_EMAIL do
    UserNotifier.receive(message)
    end
  end
end