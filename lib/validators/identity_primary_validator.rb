class IdentityPrimaryValidator < ActiveModel::EachValidator
   def validate_each(object, attribute, value)
     object.errors[:base] <<  I18n.t(:cannot_edit_primary_identity_change_email) if object.is_primary? && object.is_a?(Identity)
     object.errors[:base] <<  I18n.t(:cannot_merge_that_account) if object.is_a?(Merge) && !object.identity.is_mergeable?
   end


end
