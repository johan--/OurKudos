class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friendable, :polymorphic => true
  #belong_to
  #need a callback to update friend_type

  def update_friendship_statistics
     self.contacts_count += 1
     self.last_contacted_at = Time.now
     save :validate => false
  end

  class << self

      def process_friendships_between person, friend
        person.add_friend(friend) #if false means already on contact list
        friendship = person.friendship_for friend
        friendship.update_friendship_statistics
      end

  end

end
