class VirtualUser < ActiveRecord::Base
  has_one  :identity, :as => :identifiable, :dependent => :destroy

  include OurKudos::TwitterConnection

  def to_s
    return first_name if first_name == last_name
    "#{first_name} #{last_name[0]}."
  end

  def email
    return nil unless identity.identity_type == 'email'
    identity.identity
  end

  def virtual_name
    if first_name == last_name 
      if first_name.match(RegularExpressions.email).present?
        return first_name.match(RegularExpressions.email_username)[0]
      else
        return first_name 
      end
    end
    "#{first_name} #{last_name[0]}."
  end

  def update_from_twitter identity
    user_info = get_user_info identity
    self.update_attributes user_info unless user_info.blank?
    return true
  end

  #Class Methods
  class << self
    def process_new_kudo kudo
      new_virtual_users = []
      recipients = kudo.recipients_list 

      recipients.each do |recipient|
        next if recipient.to_i != 0 || recipient[0..2] == "fb_"
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
      new_kudo_to  = kudo.to.split(",").map{ |id| id.gsub("'",'').gsub(" ",'') }
      identities.each do |identity|
        identity_to_replace = identity.identity
        identity_to_replace = "@#{identity_to_replace}" if identity.identity_type == 'twitter'
        new_kudo_to.delete(identity_to_replace)
        new_kudo_to << "'#{identity.id.to_s}'"
      end
      kudo.to = new_kudo_to.join(",")
      kudo.save(:validate => false)
    end

    def update_kudo_copies identity
      copies =  KudoCopy.where(:temporary_recipient => identity.identity)
      copies.each do |copy|
        copy.recipient_id = identity.identifiable_id 
        copy.recipient_type = identity.identifiable_type
        copy.temporary_recipient = nil
        copy.save!(:validate => false)
      end
    end

    def update_from_member virtual_users
      virtual_users.each do |user|
        virtual_user = VirtualUser.find(user[0])
        unless virtual_user.blank?
          attributes = {:first_name => user[1][:first_name],
                        :last_name => user[1][:last_name] }
          return false unless virtual_user.update_attributes attributes
        end
      end
      true
    end


  end

end
