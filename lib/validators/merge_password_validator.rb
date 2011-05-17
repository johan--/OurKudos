class MergePasswordValidator < ActiveModel::EachValidator
   def validate_each(object, attribute, value)
     object.errors[:base] << I18n.t(:wrong_password_for_merge)  unless object.merged.valid_password?(value)
   end
end
