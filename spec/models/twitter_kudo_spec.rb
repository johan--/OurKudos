require 'spec_helper'

describe TwitterKudo do
  context "facebook kudo instance" do


    let(:twitter_kudo)   { Factory(:twitter_kudo) }

    it 'should post itself asynchronously right after saving' do
      DelayedJob.destroy_all
      twitter_kudo.should respond_to "post_me!"

      before = Delayed::Job.count
      twitter_kudo.posted.should be_false

      twitter_kudo.post_me!

      Delayed::Job.count.should == before + 1
    end

   end

end
