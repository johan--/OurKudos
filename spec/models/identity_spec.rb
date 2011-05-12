require 'spec_helper'

describe Identity do

  it 'should be able to get all its types' do
    Identity.should respond_to 'options_for_identity_type'
    Identity.options_for_identity_type.should be_an_instance_of Array
    Identity.options_for_identity_type.first.should be_an_instance_of Array
  end


  context 'given an instance' do
    let(:identity) do
          Identity.new(:identity => 'some@email.com',
                     :user => User.new,
                     :identity_type => "email")
    end

    let(:role) {Role.new(:name => "admin")}



    it 'should forbid removal if is set as primary identity' do
      identity.is_primary = true
      identity.destroy.should be_false
      identity.should respond_to 'can_destroy?'
      identity.can_destroy?.should be_false
    end

    it "should be able to update to keep up to date its identity if identity is an email" do
      identity.user.email = 'some@other.email.com'
      identity.should respond_to "synchronize_email!"
      identity.synchronize_email!.should be_true
      identity.identity.should == identity.user.email
    end

    it 'should be able to determine if is mergeable or not' do
      identity.should respond_to 'mergeable?'
      identity.mergeable?.should be_true
      identity.user.roles << role
      identity.mergeable?.should be_false
    end

    it 'should be able to set identity as tetriary' do
      identity.should respond_to 'set_as_tetriary!'
      identity.is_primary = true
      identity.save
      identity.set_as_tetriary!
      identity.is_primary.should be_false
    end

  end

end
