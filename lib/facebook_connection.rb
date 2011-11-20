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
     list = clean_readable_list(kudo.recipients_readable_list)
     message = kudo.body
     unless kudo.attachment_id.blank?
       message += attachment_link kudo
     end
     message += "\nShared with: #{list}"
     begin
      result = facebook_user.feed!(:message    => message,
                                   :link       => "http://rkudos.com/kudos/#{kudo.id}",
                                   :name       => 'OurKudos',
                                   :description => "It's all good!")
      result.is_a?(FbGraph::Post)
     rescue Errno, Exception => e
       Rails.logger.info "SOCIAL_POSTING: Failed to post facebook kudo #{e.to_s}"
       e.to_s
     end
   end

   def post_to_friends_wall friend, kudo
     message = kudo.body
     unless kudo.attachment_id.blank?
       message += attachment_link kudo
     end
     begin
       fb_friend = FbGraph::User.new(friend, :access_token => facebook_auth.token)
       result =    fb_friend.feed!(:message    => message,
                                   :link       => "http://rkudos.com/kudos/#{kudo.id}",
                                   :name        => 'OurKudos',
                                   :description => "It's all good!")
        result.is_a?(FbGraph::Post)
     rescue Errno, Exception => e
       # puts '----'
       # puts 'error'
       # puts e.inspect
       # puts '----'
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

    def clean_readable_list(list)
      cleaned_list = list.gsub(',unknown recipient','').gsub('unknown recipient,', '')
      cleaned_list.gsub(",",", ")
    end

    def attachment_link kudo
      "\nwww.rkudos.com/cards/#{kudo.attachment.id}"
    end
  end
end
