require 'spec_helper'

describe Kudo do
  context "class" do

    before :all do
      Settings.seed
    end

    it 'should know about ability to share kudos on social sites' do

      Kudo.should respond_to "social_sharing_enabled?"

      setting = Settings[:social_sharing_enabled]
      setting.value = 'yes'
      setting.save

      Kudo.social_sharing_enabled?.should be_true
    end


    context "an instance" do
      let(:new_kudo) { Kudo.new }

      it 'should know about all recipients' do
        new_kudo.to = "1,2,3, ulversson@gmail.com"

        new_kudo.recipients_list.should be_an_instance_of(Array)
        new_kudo.recipients_list.size.should == 4
      end

      it 'should display list with all recipients separated by comma' do
        new_kudo.recipients_readable_list.should be_blank

        identity        = Factory(:identity)
        facebook_friend = Factory(:facebook_friend)

        new_kudo.to = "#{identity.id}, some@email.com, fb_some_facebook_id"

        new_kudo.prepare_copies

        new_kudo.recipients_readable_list.include?(identity.user.to_s).should be_true
        new_kudo.recipients_readable_list.include?("some@email.com").should be_true
        new_kudo.recipients_readable_list.include?(facebook_friend.name).should be_true
      end

    end

  end
end