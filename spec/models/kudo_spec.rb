require 'spec_helper'

describe Kudo do
  context "class" do

    before :all do
      Settings.seed!
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
        new_kudo.to = ''
        new_kudo.share_scope = 'friends'

        identity        = Factory(:identity, :display_identity => true)
        email           = "some@email.com"

        new_kudo.to = "#{identity.id}"

        new_kudo.prepare_copies
        new_kudo.save

        new_kudo.recipients_readable_list.include?(identity.user.secured_name ).should be_true
        new_kudo.recipients_readable_list.include?("some@email.com").should be_false
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

    describe "recipients lists" do

      context "with social sharing disabled" do
        it "should return twitter handle as name if no twitter identity" do
          sharing =  Settings.find_by_name("social-sharing-enabled")
          sharing.update_attribute('value', 'no')

          kudo = Factory(:kudo, :to => "'@ourkudos'")

          kudo.recipients_readable_list.should eq("@ourkudos")
        end

      end
    end

  end

  describe "deleting a kudo" do
    before(:each) do 
      @user = Factory(:user)
    end

    describe "user is only recipient" do
      before(:each) do
        @kudo = Factory(:kudo, :to => @user.primary_identity.id.to_s)
      end

      it "should respond to user_is_only_recipient" do
        @kudo.should respond_to 'user_is_only_recipient?'
        @kudo.user_is_only_recipient?(@user).should be(true)
      end

      it "should be deletable by user" do
        @kudo.should respond_to 'can_be_deleted_by?'
        @kudo.can_be_deleted_by?(@user).should be(true)
      end
    end

    describe "multiple recipients" do
      before(:each) do
        @user2 = Factory(:user)
        @kudo = Factory(:kudo, :to => "#{@user.primary_identity.id}, #{@user2.primary_identity.id}")
      end

      describe "no recipients have deleted the kudo" do
        it "should be not be able to be deleted by current user" do
          @kudo.recipients.size.should > 1
          @kudo.can_be_deleted_by?(@user).should be(false)
        end
      end

      describe "all recipients but user have deleted kudo" do
        before(:each) do
          @kudo.hide_for! @user2
        end

        it "should show user is in recipients who havent deleted kudo" do
          @kudo.should respond_to 'recipients_who_have_not_deleted'
        end

        it "should show only user who has not deleted kudo" do
          @kudo.recipients_who_have_not_deleted.size.should eq(1)
          @kudo.recipients_who_have_not_deleted.first.should eq(@user.id)
        end

        it "should respond to last to delete kudo" do
          @kudo.should respond_to 'is_last_to_delete?'
          @kudo.is_last_to_delete?(@user).should be(true)
        end

        it "should be deletable by user" do
          @kudo.can_be_deleted_by?(@user).should be(true)
        end
      end
    end

  end
end
