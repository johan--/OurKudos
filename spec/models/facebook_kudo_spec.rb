require 'spec_helper'

describe FacebookKudo do


  context "facebook kudo instance" do


    let(:facebook_kudo)   { Factory(:facebook_kudo) }




    it 'should post itself asynchronously right after saving' do
      DelayedJob.destroy_all
      facebook_kudo.should respond_to "post_me!"

      before = Delayed::Job.count
      facebook_kudo.posted.should be_false

      facebook_kudo.post_me!

      Delayed::Job.count.should == before + 1
    end

   end

end
