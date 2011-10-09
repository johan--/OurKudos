require "net/http"
require "json"
require 'fb_graph'

namespace :testing_facebook do
    config = Hash.new
    config[:client_id] = 246653275379515
    config[:client_secret]= "9af58b53422b54b92e2615ca2e41bd0f"
      
    task :reset do
      app = FbGraph::Application.new(config[:client_id], :secret => config[:client_secret])
      app.test_users.collect(&:destroy)

      user = Hash.new
      user[:one] = app.test_user!(:name => "Mickey", :installed => true, :permissions => :read_stream)
      user[:two] = app.test_user!(:name => "Walt", :installed => true, :permissions => :read_stream)
      user[:three] = app.test_user!(:name => "Steve", :installed => true, :permissions => :read_stream)

      #p user1, user2
      user[:one].friend!(user[:two])
      user[:one].friend!(user[:three])
      
      File.open('test_users.txt', 'w') do |f|  
        f.puts "Link user #{user[:one].identifier} to Our Kudos account"
        user.each do |key, value|
          f.puts "-----------------------"
          f.puts "#{value.identifier}"
          f.puts "Login Url: #{value.login_url}"
          f.puts "User Id: #{value.identifier}"
          f.puts "Password: #{value.password}"
          f.puts "Access Token: #{value.access_token}"
          f.puts "-----------------------"
        end
      end 
    end

end
