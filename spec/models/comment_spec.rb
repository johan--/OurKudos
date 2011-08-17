require 'spec_helper'

describe Comment do

  describe "kudo comment mailers" do
    before(:each) do
      @author = Factory(:user, :id => 1)
      @kudo = Factory(:kudo, :author_id => @author.id)
      @user = Factory(:user, :id => 1337)
    end

    describe "comment author by a recipient or author" do

      it "should not send a moderation email" do
        count = DelayedJob.count
        comment = Comment.create!(  :title => "",
                                    :comment => "Rspec is great",
                                    :commentable_id => @kudo.id,
                                    :commentable_type => "Kudo",
                                    :user_id => @author.id)
        DelayedJob.count.should eq(count) 
      end

    end

    describe "comment author not a recipient our author" do
      it "should send a moderation email" do
        count = DelayedJob.count
        comment = Comment.create!(  :title => "",
                                    :comment => "Rspec is great",
                                    :commentable_id => @kudo.id,
                                    :commentable_type => "Kudo",
                                    :user_id => @user.id)
        DelayedJob.count.should eq(count + 1) 
      end
    end

  end
  
end
