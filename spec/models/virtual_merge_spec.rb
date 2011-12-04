require 'spec_helper'

describe VirtualMerge do

  describe 'friendships' do
    before(:each) do
      @user = Factory(:user)
    end

    it 'should create a virtual friendship for virtual recipient' do
      @user.friendships.should be_blank
      Factory(:kudo, :author => @user, :to => 'not@real.com')

      user = User.find(@user.id)
      user.friendships.count.should eq(1)
      friendship = user.friendships.first
      friendship.friendable_type.should eq('VirtualUser')
      friendship.friendable.should be_an_instance_of(VirtualUser)

    end

    it 'should merge friendship to the new user account' do
      Factory(:kudo, :author => @user, :to => 'not@real.com')

      virtual_user = Identity.find_by_identity('not@real.com')
      user = User.find(@user.id)
      VirtualMerge.create!(:merged_by => user.id, 
                            :merged_id => virtual_user.identifiable_id,
                            :identity_id => virtual_user.id)
      friendship = user.friendships.first
      friendship.friendable_type.should eq('User')
      friendship.friendable.should be_an_instance_of(User)
    end

    it 'should add contacts if friendship exists before merge' do
      virtual_user = Factory(:virtual_user,
                             :first_name => 'Steve',
                             :last_name => 'Jobs')
      Factory(:friendship, :user => @user, :friendable => virtual_user) 

      Factory(:kudo, :author => @user, :to => 'not@real.com')
      virtual_identity = Identity.find_by_identity('not@real.com')
      user = User.find(@user.id)
      VirtualMerge.create!(:merged_by => user.id, 
                            :merged_id => virtual_user.id,
                            :identity_id => virtual_identity.id)
      friendship = user.friendships.first
      friendship.friendable_type.should eq('User')
      friendship.friendable.should be_an_instance_of(User)
    end
  end

  describe 'performing a merge' do
    before(:each) do
      @user = Factory(:user)
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
      @kudo = Factory(:kudo, :to => @identity.id.to_s)
      @merge = VirtualMerge.create( :merged_by => @user.id,
                                    :merged_id => @virtual_user.id,
                                    :identity_id => @identity.id)
    end
    
    it 'should merge the identity to the user' do
      @merge.run!
      identity = Identity.find(@identity.id)
      identity.identifiable.should eq(@user)
    end

    it 'should update the kudo copies' do
      @merge.run!
      copy = KudoCopy.find(@kudo.kudo_copies.first.id)
      copy.recipient.should eq(@user)
    end

    it 'should not be a twitter merge' do
      @merge.not_twitter?.should be_true
      @merge.is_twitter?.should be_false
    end

  end

  describe 'adding a twitter confirmation' do
    before(:each) do
      @user = Factory(:user)
      @virtual_user = Factory(:virtual_user, 
                              :first_name => '',
                              :last_name => '')
      @identity = Identity.new(:identifiable_id => @virtual_user.id,
                               :identifiable_type => 'VirtualUser',
                               :identity => '@jobs',
                               :identity_type => 'twitter',
                               :is_primary => true,
                               :display_identity => true)
      @identity.save(:validate => false)
      @kudo = Factory(:kudo, :to => @identity.id.to_s)
      @merge = VirtualMerge.create( :merged_by => @user.id,
                                    :merged_id => @virtual_user.id,
                                    :identity_id => @identity.id)
    end

    it 'should save twitter confirmation' do
      VirtualMerge.stub!('update_identity').and_return(true)
      lambda {
        @merge.save_twitter_confirmation!
      }.should change(Confirmation, :count).by(1)
    end

  end
end
