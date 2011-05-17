class AuthenticationObserver < ActiveRecord::Observer

  def after_save authentication
    if authentication.provider == 'twitter' && Identity.find_by_identity_type_and_identity('twitter', authentication.nickname).blank?
      authentication.user.identities.create :identity_type => "twitter",
                                            :identity      => authentication.nickname

    end
  end

end
