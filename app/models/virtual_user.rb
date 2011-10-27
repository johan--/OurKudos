class VirtualUser < ActiveRecord::Base
  has_many  :identities, :as => :identifiable

  class << self
    def process_new_kudo kudo
      new_virtual_users = []
      recipients = kudo.recipients_list 

      recipients.each do |recipient|
        next if recipient.to_i != 0
        type = get_identity_type recipient
        new_virtual_users << {:identity => recipient, :type => type}
      end
      create_new_virtual_user_and_identities new_virtual_users, kudo unless new_virtual_users.empty?
    end

    def get_identity_type string
      return "twitter" if string[0] == '@'
      return Identity.get_type string
    end

    def create_new_virtual_user_and_identities recipients, kudo
      recipients_to_replace = []
      recipients.each do |recipient|
        user = create_virtual_user recipient
        new_identity = create_identity recipient, user
        recipients_to_replace << new_identity
      end
      update_kudo kudo, recipients_to_replace
    end

    def create_virtual_user recipient
      user = VirtualUser.new(:first_name => recipient[:identity],
                             :last_name =>  recipient[:identity])
      user.save
      user
    end

    def create_identity recipient, virtual_user
      recipient[:identity] = recipient[:identity].gsub("@",'') if recipient[:identity][0] == "@"
      identity = Identity.new(:identity => recipient[:identity],
                              :identity_type => recipient[:type],
                              :identifiable_id => virtual_user.id,
                              :identifiable_type => 'VirtualUser')
      identity.save(:validate => false)
      update_kudo_copies identity
      identity
    end

    def update_kudo kudo, identities
      new_kudo_to = []
      identities.each do |identity|
        identity_to_replace = identity.identity
        identity_to_replace = "@#{identity_to_replace}" if identity.identity_type == 'twitter'
        old_kudo_to = kudo.to
        new_kudo_to << old_kudo_to.gsub(identity_to_replace, identity.id.to_s)
      end
      kudo.to = new_kudo_to.join(",")
      kudo.save(:validate => false)
    end

    def update_kudo_copies identity
      copies =  KudoCopy.where(:temporary_recipient => identity.identity)
      copies.each do |copy|
        copy.recipient_id = identity.id 
        copy.temporary_recipient = nil
        copy.save!(:validate => false)
      end
    end

  end

end
