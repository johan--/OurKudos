# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Role.create([
    {:name => "admin"},
    {:name => "editor"},
    {:name => "user"}
  ])

 admin = User.create(:email =>"admin@example.net",
               :password => "admin123",
               :password_confirmation => "admin123",
               :first_name => "Admin",
               :confirmed  => true, 
               :last_name => "Big Boss")

 admin.roles << Role.first
 admin.save :validate => false

 admin.identities.first.confirm!
