module OurKudos
  module VirtualHelpers

    def self.update_copies(virtual_user, user)
      kudo_copies = KudoCopy.where(:recipient_id => virtual_user.id,
                                   :recipient_type => virtual_user.class.to_s)
      kudo_copies.each do |copy|
        copy.update_attributes(:recipient_id => user.id,
                               :recipient_type => user.class.to_s)
      end
    end

    def self.update_friendships(virtual_user, user)
      friendships = Friendship.where(:friendable_id => virtual_user.id,
                                     :friendable_type => virtual_user.class.to_s)
      friendships.each do |friendship_to_update|
        existing_friendships = virtual_user.friendships
        if existing_friendships.any?
          existing_friendships.first.update_friendship_statistics
          friendship_to_update.destroy
        else
          friendship_to_update.friendable_id = user
          friendship_to_update.friendable_type = user.class.to_s
          friendship_to_update.save(:validate => false)
        end
      end
    end

    def self.update_identity(identity, user)
      identity.identifiable_id = user.id
      identity.identifiable_type = 'User'
      identity.is_primary = true
      identity.display_identity = true
      identity.save(:validate => false)
      identity.confirmation.resend!
    end

  end
end
