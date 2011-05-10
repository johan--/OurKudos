class IdentityPrimaryValidator < ActiveModel::EachValidator
   def validate_each(object, attribute, value)
     object.errors[:base] <<  I18n.t(:cannot_edit_primary_identity_change_email) if object.is_primary? 
   end


end
