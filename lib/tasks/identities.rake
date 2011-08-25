namespace :identities do
      task :generate => :environment  do
        puts "Collectiong users with empty identities..."
        users = User.joins("LEFT OUTER JOIN identities ON users.id = identities.user_id")
                    .where("identity IS NULL")
        puts "Updating rows..."
        users.each {|user| user.save_identity   }
        puts "Done."

      end

      task :create_confirmations => :environment do
        puts "Collectiong identitites with no confirmations..."
        identities = Identity.joins("LEFT OUTER JOIN confirmations ON identities.id = confirmations.confirmable_id")
                           .where("confirmable_id IS NULL")
                           .where(:identity_type => "email")
        puts "Updating rows..."

       identities.each  do |identity|
          identity.save_confirmation         if identity.identity_type == "email"
          identity.save_twitter_confirmation if identity.identity_type == "twitter"
        end
        
        puts "Done."
      end

      task :reset_display_name => :environment  do
        identities = Identity.where(:is_primary => true)
        identities.each do |identity| 
          puts "updating #{identity.user.to_s}..."
          identity.update_attribute("display_identity", true)
          puts "update done"
        end
      end

end
