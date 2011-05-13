ENV['DB'] ||= 'sqlite3'
require File.join(File.dirname(File.expand_path("./", __FILE__)), 'models.rb')
require 'rspec'
require 'sqlite3'

MODELS =  [MergeableModel, User, NotMergeableModel]

database_yml = File.expand_path('../database.yml', __FILE__)

if File.exists?(database_yml)
  active_record_configuration = YAML.load_file(database_yml)[ENV['DB']]

  ActiveRecord::Base.establish_connection(active_record_configuration)  
  
  MODELS.each do |model|
    ActiveRecord::Base.connection.execute "DROP TABLE #{model.table_name}"
  end

  ActiveRecord::Base.silence do
    ActiveRecord::Migration.verbose = false

    require File.join(File.dirname(File.expand_path("./", __FILE__)), 'models.rb')
    require File.join(File.dirname(File.expand_path("./", __FILE__)), 'schema.rb')
  end

else
  raise "Please create #{database_yml} first to configure your database. Take a look at: #{database_yml}.sample"
end

RSpec.configure do |config|
  config.mock_with :rspec
end

def clean_database!
  MODELS.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end
