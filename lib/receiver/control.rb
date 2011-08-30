# coding: UTF-8
#!/usr/bin/env ruby

require 'rubygems'
require 'daemons'

daemon_options = {
  :app_name   => 'receive_emails',
  :multiple   => false,
  :dir_mode   => :script,
  :dir        => "pids",
  :backtrace  => false,
  :monitor    => true,
  :log_output => false
}
Daemons.run('receive_emails.rb', daemon_options)