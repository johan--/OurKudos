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
      virtual_user.first_name.should eq("")
      virtual_user.last_name.should eq("")
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
      identity = Identity.find_by_identity('mickeymouse')
      virtual_user = identity.identifiable
      KudoCopy.first.recipient_id.should eq(virtual_user.id)
    end

    it 'should show that the kudo knows about the new virtual identity' do
      @kudo = Factory(:kudo, :author => @user, :to => "@mickey")
      KudoCopy.count.should eq(1)
      identity = Identity.find_by_identity('mickey')
      virtual_user = identity.identifiable
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

    it 'should be not unique on first and last name' do
      user2 = Factory(:virtual_user, :first_name => 'Steve', :last_name => 'Jobs')
      user2.update_attributes(:first_name => 'Walt', :last_name => 'Disney')
      user2.should be_valid
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

  describe 'an instance' do
    before(:each) do 
      @virtual_user = Factory(:virtual_user)
      @identity = Identity.new(:identifiable_id => @virtual_user.id,
                               :identifiable_type => 'VirtualUser',
                               :identity => 'steve@jobs.com',
                               :identity_type => 'email',
                               :is_primary => true,
                               :display_identity => true)
      @identity.save(:validate => false)
    end

    it 'should never have a role' do
      @virtual_user.has_role?('made_up').should be_false
    end

    it 'should return an empty array for authentications' do
      @virtual_user.authentications.should eq([])
    end

    it 'should return identity as an array for identities' do
      @virtual_user.identities.should eq([@identity])
    end

  end

  describe 'a virtual user becoming an user' do
    before(:each) do
      @user = Factory(:user)
      @virtual_user = Factory(:virtual_user)
      @identity = Identity.new(:identifiable_id => @virtual_user.id,
                               :identifiable_type => 'VirtualUser',
                               :identity => 'steve@jobs.com',
                               :identity_type => 'email',
                               :is_primary => true,
                               :display_identity => true)
      @identity.save(:validate => false)
      @kudo = Factory(:kudo, :to => @identity.id.to_s)
    end

    it 'should update identity to become user' do
      @virtual_user.merge(@user)
      identity = Identity.find(@identity.id)
      identity.identifiable.should eq(@user)
    end

    it 'should update kudo copies recipient' do
      @virtual_user.merge(@user)
      copy = KudoCopy.find(@kudo.kudo_copies.first.id)
      copy.recipient.should eq(@user)
    end


  end

  describe 'virtual user names' do
    before(:each) do 
      @virtual_user = Factory(:virtual_user, 
                              :first_name => '',
                              :last_name => '')
      @identity = Identity.new(:identifiable_id => @virtual_user.id,
                               :identifiable_type => 'VirtualUser',
                               :identity => 'steve@jobs.com',
                               :identity_type => 'email',
                               :is_primary => true,
                               :display_identity => true)
      @identity.save(:validate => false)
    end

    it 'should return email name if type is email' do
      @virtual_user.to_s.should eq('steve')
    end

    it 'should return identity if type is twitter' do
      @identity.identity = 'stevejobs'
      @identity.identity_type = 'twitter'
      @identity.save(:validate => false)
      @virtual_user.to_s.should eq('@stevejobs')
      @virtual_user.secured_name.should eq('@stevejobs')
    end

    it 'should return identity if type is other' do
      @identity.identity = 'stevejobs'
      @identity.identity_type = 'other'
      @identity.save(:validate => false)
      @virtual_user.to_s.should eq('stevejobs')
      @virtual_user.secured_name.should eq('stevejobs')
    end

    it 'should return first name last initial if name not blank' do
      @virtual_user.update_attributes(:first_name => 'Steve',
                                      :last_name => 'Jobs')
      @virtual_user.to_s.should eq('Steve J.')
      @virtual_user.secured_name.should eq('Steve J.')
    end

  end

end

