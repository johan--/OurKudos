require 'spec_helper'

describe Comment do

  describe "kudo comment mailers" do
    before(:each) do
      @recipient = Factory(:user, :id => 1)
      @kudo = Factory(:kudo)
      @user = Factory(:user, :id => 1337)
    end

    describe "comment by a recipient" do

      it "should send a moderation email when recipient comments" do
        lambda {
          Comment.create!(  :title => "",
                                    :comment => "Rspec is great",
                                    :commentable_id => @kudo.id,
                                    :commentable_type => "Kudo",
                                    :user_id => @kudo.recipients.first.id)
        }.should change(DelayedJob, :count).by(1)
      end

      it "should not send a moderation email when author comments" do
        lambda {
          comment = Comment.create!(  :title => "",
                                      :comment => "Rspec is great",
                                      :commentable_id => @kudo.id,
                                      :commentable_type => "Kudo",
                                      :user_id => @kudo.author.id)
        }.should_not change(DelayedJob, :count)
      end

    end

    describe "comment author not a recipient" do
      it "should send a moderation email" do
        lambda {
          comment = Comment.create!(:title => "",
                                    :comment => "Rspec is great",
                                    :commentable_id => @kudo.id,
                                    :commentable_type => "Kudo",
                                    :user_id => @user.id)
        }.should change(DelayedJob, :count)
      end
    end

  end
  
end
