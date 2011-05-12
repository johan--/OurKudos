namespace :identities do
      task :generate => :environment  do
        puts "Collectiong users with empty identities..."
        users = User.joins("LEFT OUTER JOIN identities ON users.id = identities.user_id")
                    .where("identity IS NULL")
        puts "Updating rows..."
        users.each {|user| user.write_identity   }
        puts "Done"

      end
end