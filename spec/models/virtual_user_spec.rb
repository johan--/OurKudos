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

    it 'should create a newvirtual user from a nonmember email' do
      lambda {
        @kudo = Factory(:kudo, :to => "walt@disney.com")
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
      KudoCopy.first.recipient_id.should eq(virtual_user.id)
    end

    it 'should show that the kudo knows about the new virtual identity' do
      @kudo = Factory(:kudo, :author => @user, :to => "@mickey")
      KudoCopy.count.should eq(1)
      virtual_user = VirtualUser.find_by_first_name('@mickey')
      @kudo.virtual_recipients.should include(virtual_user)
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
    end
    
    it "should save virtual identity as kudo recipient" do
      @kudo = Factory(:kudo, :to => "@stevejobs")
      @kudo.to.should include(@identity.id.to_s)
    end
  end

  describe 'updating a virtual users first and last name' do
    before(:each) do
      @user = Factory(:virtual_user, :first_name => 'Walt', :last_name => 'Disney')
      @identity = Identity.new( :identifiable_id => @user.id,
                                :identifiable_type => "VirtualUser",
                                :identity => "stevejobs",
                                :identity_type => 'twitter')
      @identity.save(:validate => false)
    end

    it 'should be able to update first name and last name' do
      @user.update_attributes(:first_name => 'steve', :last_name => 'jobs')
      @user.first_name.should eq('steve')
      @user.last_name.should eq('jobs')
      @user.should be_valid
    end

    it 'should be unique on first and last name' do
      user2 = Factory(:virtual_user, :first_name => 'Steve', :last_name => 'Jobs')
      user2.update_attributes(:first_name => 'Walt', :last_name => 'Disney')
      user2.should_not be_valid
    end

  end

  describe "virtual user instance methods" do
    before(:each) do
      @user = Factory(:virtual_user)
      @identity = Identity.new( :identifiable_id => @user.id,
                                :identifiable_type => "VirtualUser",
                                :identity => "steve@jobs.com",
                                :identity_type => 'email')
      @identity.save(:validate => false)
    end
    
    it 'should have an email if it has an email identity' do
      @user.email.should eq('steve@jobs.com')
    end
  end

end

