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

        copy = new_kudo.send_twitter_kudo "@twitter_handle", 'self'

        copy.kudoable.should be_an_instance_of(TwitterKudo)
      end

      it 'should be able to send a facebook kudo' do
        new_kudo.kudo_copies.destroy_all
        new_kudo.should respond_to 'send_facebook_kudo'

        copy = new_kudo.send_facebook_kudo "12345676543", "wall"

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

      describe "recipients readable list on email kudo" do
        before(:each) do
          @to_user = Factory(:user, 
                             :id => 1337,
                             :first_name => "Steve", 
                             :last_name => "Jobs")
          @author = Factory(:user, 
                            :id => 1923,
                            :first_name => "Walt", 
                            :last_name => "Disney")
          @kudo = Factory( :kudo, 
                                  :author => @author, 
                                  :to => @to_user.primary_identity.identity)
        end

        it "should return the to user in the recipients readable list" do
          @kudo.recipients_readable_list.should include("Steve J.")
        end

        it "should not return the author in the recipients readable list" do
          @kudo.recipients_readable_list.should_not include("Walt")
        end

        it "should return the to user in the recipients names Ids" do
          @kudo.recipients_names_ids.should eq([["Steve J.", 1337]])
        end

      end

      describe "recipients readable list on Facebook kudo" do
        before(:each) do
          @to_user = Factory(:facebook_friend, 
                             :id => 1337,
                             :first_name => "Steve", 
                             :last_name => "Jobs",
                             :facebook_id => 1337)
          @author = Factory(:user, 
                            :id => 1923,
                            :first_name => "Walt", 
                            :last_name => "Disney")
          @kudo = Factory(  :kudo, 
                            :author => @author, 
                            :to => "fb_#{@to_user.id}")
        end

        it "should return the to user in the recipients readable list" do
          @kudo.recipients_readable_list.should include("Steve J.")
        end

        it "should return the to user in the recipients names Ids" do
          @kudo.recipients_names_ids.should eq([["Steve J.", nil]])
        end

      end

      describe "recipients readable list on twitter" do
        before(:each) do
          @to_user = Factory(:user, 
                             :id => 1337,
                             :first_name => "Steve", 
                             :last_name => "Jobs")
          @author = Factory(:user, 
                            :id => 1923,
                            :first_name => "Walt", 
                            :last_name => "Disney")
          identity = Identity.new(:identity => "mickeymouse",
                                  :identity_type => "twitter",
                                  :user_id => @author.id,
                                  :is_primary =>false)
          identity.save(:validate => false)
                              
          @kudo1 = Factory( :kudo, 
                            :author => @author, 
                            :to => "@stevejobs")
          @kudo2 = Factory( :kudo, 
                            :author => @author, 
                            :twitter_sharing => true,
                            :to => "@stevejobs, @mickeymouse")
        end

        it "should return the to user in the recipients readable list with twitter sharing off" do
          @kudo1.recipients_readable_list.should include("@stevejobs")
        end

        it "should return the to user in the recipients names Ids with twitter sharing off" do
          @kudo1.recipients_names_ids.should eq([["@stevejobs", nil]])
        end

        it "should return the to user in the recipients readable list with twitter sharing on" do
          @kudo2.recipients_readable_list.should include("@stevejobs")
        end

        it "should not return the author in the recipients readable list with twitter sharing on" do
          @kudo2.recipients_readable_list.should_not include("@mickeymouse")
        end

        it "should return the to user in the recipients names Ids with twitter sharing on" do
          @kudo2.recipients_names_ids.should eq([["@stevejobs", nil]])
        end

      end

      describe "recipients readable list for unverified recipient" do

        context "share scope world" do
          it "should show unverified email recipient in recipients readable list" do
            kudo = Factory(:kudo, :to => "awesome@email.com", 
                                  :share_scope => nil)
            kudo.recipients_readable_list.should eq("awesome")
          end

          it "should show kudo as a public kudo" do
            kudo = Factory(:kudo, :to => "awesome@email.com", 
                                  :share_scope => nil)
            Kudo.public_kudos.should include(kudo)
          end
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

      it "should allow the user to delete kudo" do
        @kudo.soft_destroy
        @kudo.removed.should be(true)
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

        it "should allow the user to delete kudo" do
          @kudo.soft_destroy
          @kudo.removed.should be(true)
        end

      end
    end

  end
end
