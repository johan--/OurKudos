class Confirmation < ActiveRecord::Base

  include OurKudos::Confirmable

  before_save :generate
  belongs_to :confirmable, :polymorphic => true

   def confirmable_klass_type
     confirmable.class.name.underscore
   end

   def user
      confirmable.identifiable
   end


end
