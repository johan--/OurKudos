require 'spec_helper'

describe VirtualUser do

  before :all do
    Settings.seed!
  end

  describe 'creating a new virtual user' do
    before(:each) do
      @user = Factory(:user)
    end

    it 'should create a new virtual when kudo sent to nonmember' do
      lambda {
        @kudo = Factory(:kudo, :to => "@mickeymouse")
      }.should change(VirtualUser, :count).by(1)
    end

    it 'should intially set the first and last name to identity' do
      @kudo = Factory(:kudo, :to => "@mickeymouse")
      virtual_user = VirtualUser.first
      virtual_user.first_name.should eq("@mickeymouse")
      virtual_user.last_name.should eq("@mickeymouse")
    end

    it 'should create a new identity for the new virtual user' do
      lambda {
        @kudo = Factory(:kudo, :author => @user, :to => "@mickeymouse")
      }.should change(Identity, :count).by(1)
    end

    it 'should update the kudo to reference the new identity' do
      @kudo = Factory(:kudo, :author => @user, :to => "@mickeymouse")
      identity = Identity.find_by_identity('mickeymouse')
      @kudo.to.should include(identity.id.to_s)
      @kudo.to.should_not include('mickeymouse')
    end

    it 'should update any associated kudo copies' do
      @kudo = Factory(:kudo, :author => @user, :to => "@mickeymouse")
      KudoCopy.count.should eq(1)
      virtual_user = VirtualUser.find_by_first_name('@mickeymouse')
      KudoCopy.first.recipient_id.should eq(virtual_user.identities.first.id)
    end
    #should update a virtual user when sent them
  end

  describe 'send a kudo to an existing virtual user' do
    before(:each) do
      @user = Factory(:virtual_user)
      @identity = Identity.new( :identifiable_id => @user.id,
                                :identifiable_type => "VirtualUser",
                                :identity => "stevejobs",
                                :identity_type => 'twitter')
      @identity.save(:validate => false)
    end

    it "should not create a new virtual user if identity exists" do
      author = Factory(:user)
      lambda {
        @kudo = Factory(:kudo, :author => author, :to => "@stevejobs")
      }.should_not change(Identity, :count)
      #@kudo.to.should include(@identity.id.to_s)
    end
    
    it "should save virtual identity as kudo recipient" do
      @kudo = Factory(:kudo, :to => "@stevejobs")
      @kudo.to.should include(@identity.id.to_s)
    end
  end

end

