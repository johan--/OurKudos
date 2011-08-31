#!/usr/bin/env ruby

require 'rubygems'
require 'daemons'

daemon_options = {
  :app_name   => 'receive_emails',
  :multiple   => false,
  :dir        => "pids",
  :monitor    => true,
  :log_output => true
}
Daemons.run 'receive_emails.rb', daemon_options
