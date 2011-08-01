require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the Admin::PagesHelper. For example:
#
# describe Admin::PagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe KudosHelper do

  describe "last sent kudos cookies" do 
    describe "last kudo sent with facebook" do

      it "should return true when cookie is set" do
        helper.request.cookies[:last_sent_with_facebook] = 'yes' 
        helper.last_sent_with_facebook?().should be(true)
      end

      it "should return false when no cookie" do
        helper.last_sent_with_facebook?().should be(false)
      end

    end

    describe "last kudo sent with twitter" do

      it "should return true when cookie is set" do
        helper.request.cookies[:last_sent_with_twitter] = 'yes' 
        helper.last_sent_with_twitter?().should be(true)
      end

      it "should return false when no cookie" do
        helper.last_sent_with_twitter?().should be(false)
      end

    end

  end

  describe "kudo share scope" do

      it "should return message for world kudo" do
        kudo = Factory(:kudo)
        helper.shared_with(kudo.share_scope).should eq("the world")
      end

      it "should return message for friend kudo" do
        friend_kudo = Factory(:kudo, :share_scope => 'friends')
        helper.shared_with(friend_kudo.share_scope).should eq("friends only")
      end

      it "should return message for recipient kudo" do
        recipients_kudo = Factory(:kudo, :share_scope => 'recipient')
        helper.shared_with(recipients_kudo.share_scope).should eq("recipient only")
      end

  end

  describe "open graphic title" do

    it "should show one recipient when kudo has one recipient" do
      author = Factory(:user, :first_name => "Bob", :last_name => "Smith")
      recipient = Factory(:user, :first_name => "John", :last_name => "Doe")
      
      kudo = Factory(:kudo, :author_id => author.id, :to => recipient.identities.first.id.to_s)
      helper.open_graphic_title(kudo).should eq("Bob Smith sent Kudos to John Doe")
    end

    it "should show message for multiple recipients" do
      author = Factory(:user, :first_name => "Bob", :last_name => "Smith")
      recipient = Factory(:user, :first_name => "John", :last_name => "Doe")
      other_user = Factory(:user, :first_name => "Walt", :last_name => "Disney")
      kudo = Factory(:kudo, :author_id => author.id, :to => "#{recipient.identities.first.id.to_s}, #{other_user.identities.first.id.to_s}")

      helper.open_graphic_title(kudo).should eq("Bob Smith sent Kudos to John Doe and others")
    end
  end

end
