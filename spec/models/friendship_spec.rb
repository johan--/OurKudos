require 'spec_helper'

describe Friendship do
  before :each do
      User.all.each {|user| user.friendships.destroy_all }
      @user          = Factory(:user)
      @future_friend = Factory(:other_user)
    end

  describe "creating a friendship via a kudo" do
    before(:each) do 
      User.all.each {|user| user.friendships.destroy_all }
      @user          = Factory(:user)
      @future_friend = Factory(:other_user)
    end

    it 'should respond to add friend' do
      @user.add_friend(@future_friend)
      @user.friendships.should_not be_blank
      @user.friendships.count.should eq(1)
      friendship = @user.friendship_for @future_friend
      friendship.update_friendship_statistics
      friendship.should be_an_instance_of(Friendship)
      friendship.contacts_count.should == 1
    end

    it "should create the friendship relationship" do 
      @user.friendships.should be_blank
      @user.friends.should be_blank

      Factory(:kudo,  :author => @user, 
                      :to => @future_friend.identities.first.id.to_s)

      user = User.find(@user.id)
      user.friendships.should_not be_blank

      friendship = user.friendships.first
      friendship.should be_an_instance_of(Friendship)
      friendship.contacts_count.should == 1

    end

    it 'should create the friendship for a virtual user' do
      Factory(:kudo,  :author => @user, 
                      :to => 'not@real.com')
      @user.friendships.should_not be_blank

      friendship = @user.friendships.first
      friendship.should be_an_instance_of(Friendship)
      friendship.contacts_count.should == 1
    end

  end

  context "class" do

    it 'should be able to process friendships between two users' do
      Friendship.should respond_to :process_friendships_between

      @user.friendships.should be_blank
      @user.friends.should be_blank

      Friendship.process_friendships_between @user, @future_friend

      user = User.find(@user.id)
      user.friendships.should_not be_blank

      friendship = user.friendships.first
      friendship.should be_an_instance_of(Friendship)
      friendship.contacts_count.should == 1
    end

    context "an instance" do
      let(:friendship) do
        Friendship.create(:user_id => Factory(:user).id, 
                          :friendable_id => Factory(:other_user).id,
                          :friendable_type => 'User',
                          :contacts_count => 0, 
                          :last_contacted_at => "1911-10-10") #old friendship :-))
      end

      it 'should updated its own statistics when called' do
        friendship.update_friendship_statistics

        friendship.contacts_count.should == 1

        friendship.last_contacted_at.year.should  == Time.now.year
        friendship.last_contacted_at.month.should == Time.now.month
        friendship.last_contacted_at.month.day == Time.now.day
      end

    end

  end
end
