require 'spec_helper'

describe FacebookFriend do


  it "should run a background task which will fetch friends" do
    FacebookFriend.should respond_to "fetch_for"

    user = Factory(:user)
    Delayed::Job.count.should == 0
    FacebookFriend.fetch_for(user)
    Delayed::Job.count.should == 1
  end
end
