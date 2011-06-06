module OurKudos
  module Facebook

   def facebook_user
     @facebook_user ||= FbGraph::User.me(facebook_auth.token).fetch rescue nil
   end

   def fetch_and_save_friends
     facebook_user.friends.each do |friend|
       facebook_friend = friend.fetch
       facebook_friends.create :first_name => facebook_friend.first_name,
                               :last_name  => facebook_friend.last_name,
                               :name       => facebook_friend.name,
                               :identifier => facebook_friend.identifier

     end if connected_with_facebook?
   end

   def post_facebook_kudo kudo
     result = facebook_user.feed!(:message => kudo.body) rescue false
     result.is_a?(FbGraph::Post)
   end

   def facebook_auth
     @facebook_auth ||= self.authentications.find_by_provider 'facebook'
   end

   def connected_with_facebook?
     !facebook_auth.blank?
   end




  end
end