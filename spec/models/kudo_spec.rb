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
      let(:new_kudo) { Factory(:kudo) }

      it 'should know about all recipients' do
        new_kudo.to = "1,2,3, ulversson@gmail.com"

        new_kudo.recipients_list.should be_an_instance_of(Array)
        new_kudo.recipients_list.size.should == 4
      end

      it 'should display list with all recipients separated by comma' do
        new_kudo.recipients_readable_list.should be_blank
        new_kudo.share_scope = 'friends'

        identity        = Factory(:identity)
        email           = "some@email.com"

        new_kudo.to = "#{identity.id}, #{email}"

        new_kudo.prepare_copies
        new_kudo.save

        new_kudo.recipients_readable_list.include?(identity.user.to_s).should be_true
        new_kudo.recipients_readable_list.include?("some@email.com").should be_true
      end

      it 'should make both user friends if system kudo was sent' do
        new_kudo.should respond_to "send_system_kudo"

        user = Factory(:user)

        new_kudo.send_system_kudo user

        user.friendships.should_not be_blank
        new_kudo.author.friendships.should_not be_blank

        user.friends.include?(new_kudo.author).should be_true
        new_kudo.author.friends.include?(user).should be_true
      end

      it 'should be able to send a twitter kudo' do
        new_kudo.kudo_copies.destroy_all

        new_kudo.should respond_to 'send_twitter_kudo'

        copy = new_kudo.send_twitter_kudo "@twitter_handle"

        copy.kudoable.should be_an_instance_of(TwitterKudo)
      end

      it 'should be able to send a facebook kudo' do
        new_kudo.kudo_copies.destroy_all
        new_kudo.should respond_to 'send_facebook_kudo'

        copy = new_kudo.send_facebook_kudo "12345676543"

        copy.kudoable.should be_an_instance_of(FacebookKudo)
      end

    end

  end
end