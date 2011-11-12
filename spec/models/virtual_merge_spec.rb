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
end
