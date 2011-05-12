require 'spec_helper'



describe Role, "validations" do
  Role.create(:name => "some role")
  
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
