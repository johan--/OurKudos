module OurKudos
  module Facebook

   def facebook_user
     @facebook_user ||= FbGraph::User.me(facebook_auth.token).fetch
   end

   def fetch_and_save_friends
     facebook_user.friends do |friend|
       facebook_friend = friend.fetch
       facebook_friends.create :first_name => facebook_friendss.first_name,
                               :last_name  => facebook_friend.last_name,
                               :name       => facebook_friend.name,
                               :identifier => facebook_friend.identifier

     end if connected_with?(:facebook)
   end

  def facebook_auth
    @facebook_auth ||=self.authentications.find_by_provider 'facebook'
  end

  def connected_with? provider
     !send("#{provider.to_s}_auth").blank?
  end




  end
end