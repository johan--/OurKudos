class VirtualUser < ActiveRecord::Base
  #has_many :identities, :userable

  class << self
    def process_new_kudo kudo
      new_virtual_users = []
      recipients = kudo.recipients_list 

      recipients.each do |recipient|
        type = get_identity_type recipient
        new_virtual_users << {:identity => recipient, :type => type}
      end
      create_new_virtual_user_and_identities new_virtual_users
    end

    def get_identity_type string
      return "twitter" if string[0] == '@'
      return Identity.get_type string
    end


    def create_new_virtual_user_and_identities recipients
      recipients.each do |recipient|
        user = create_virtual_user recipient
        #create_identity recipient, user
      end
    end

    def create_virtual_user recipient
      user = VirtualUser.new(:first_name => recipient[:identity],
                             :last_name =>  recipient[:identity])
      user.save
    end

   # def create_identity recipient, virtual_user
   #   Identity.new( :identity => recipient.identity,
   #                 :identity_type => recipient.type,
   #                 :userable => virtual_user,
   #                 :userable_type => 'VirtualUser')
   # end

  end

end
