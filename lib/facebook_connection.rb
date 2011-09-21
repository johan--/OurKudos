module OurKudos
  module FacebookConnection

   def facebook_user
     @facebook_user ||= FbGraph::User.me(facebook_auth.token).fetch rescue nil
   end

   def fetch_and_save_friends
     facebook_user.friends.each do |friend|
       facebook_friend = friend.fetch
       facebook_friends.create :first_name  => facebook_friend.first_name,
                               :last_name   => facebook_friend.last_name,
                               :name        => facebook_friend.name,
                               :facebook_id => facebook_friend.identifier
     end if connected_with_facebook?
   end

   def post_facebook_kudo kudo
     begin
      result = facebook_user.feed!(:message    => kudo.body,
                                   :link       => "http://preview.ourkudos.com/kudos/#{kudo.id}",
                                   :name       => 'OurKudos',
                                   :description => "It's all good!")
      result.is_a?(FbGraph::Post)
     rescue Errno, Exception => e
       Rails.logger.info "SOCIAL_POSTING: Failed to post facebook kudo #{e.to_s}"
       e.to_s
     end
   end

   def post_to_friends_wall friend, kudo
     begin
       fb_friend = FbGraph::User.new(friend, :access_token => facebook_auth.token)
       result =    fb_friend.feed!(:message    => kudo.body,
                                   :link       => "http://preview.urkudos.com/kudos/#{kudo.id}",
                                   :name       => 'OurKudos',
                                   :description => "It's all good!")
        result.is_a?(FbGraph::Post)
     rescue Errno, Exception => e
       Rails.logger.info "SOCIAL_POSTING: Failed to post facebook kudo on friends wall #{e.to_s}"
       e.to_s
     end
   end

   def facebook_auth
     @facebook_auth ||= self.authentications.find_by_provider 'facebook'
   end

   def connected_with_facebook?
     !facebook_auth.blank?
   end




  end
end