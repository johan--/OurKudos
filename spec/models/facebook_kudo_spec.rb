require 'spec_helper'

describe FacebookKudo do


  context "facebook kudo instance" do


    let(:facebook_kudo)   { Factory(:facebook_kudo) }




    it 'should post itself asynchronously right after saving' do
      DelayedJob.destroy_all
      facebook_kudo.should respond_to "post_me!"

      Delayed::Job.count.should == 0
      facebook_kudo.posted.should be_false

      facebook_kudo.post_me!

      Delayed::Job.count.should == 1
      facebook_kudo.posted.should be_true
    end

   end

end
