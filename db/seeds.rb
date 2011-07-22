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
    {:name => "user"},
    {:name => "gift editor"}
  ])

 admin = User.create(:email =>"admin@example.net",
               :password => "Kud05adm1n",
               :password_confirmation => "Kud05adm1n",
               :first_name => "Admin",
               :confirmed  => true, 
               :last_name => "Big Boss")

 admin.roles << Role.find_by_name("admin")
 admin.save :validate => false

 admin.identities.first.confirm!

 Settings.seed!
 KudoCategory.seed!
 Page.seed!