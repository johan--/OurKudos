require 'spec_helper'

describe VirtualMergesController do

  before :all do
    Settings.seed!
  end

  before(:each) do 
    @user = Factory(:user)
    sign_in @user
    @virtual_user = Factory(:virtual_user, :first_name => "Walt", :last_name => "Disney")
  end
  
  describe 'creating a new merge' do

    describe 'email identity' do
      before(:each) do 
        @identity = Identity.new(:identifiable => @virtual_user,
                                 :identity => 'not@real.com',
                                 :identity_type => 'email')
        @identity.save(:validate => false)
        @valid_params = {:identity => 'not@real.com'}
      end

      it 'should create a virtual merge' do
        lambda{
          post :create,  @valid_params 
        }.should change(VirtualMerge, :count).by(1)
      end

      it 'should set the flash for email message' do
        post :create,  @valid_params 
        response.should be_redirect
        flash[:notice].should eq('Message has been sent. For further instructions, please check email address associated with your merge account')
      end
    end

    describe 'twitter identity' do
      before(:each) do 
        #need to stub twitter connect
        #If you wan't to add this identity please make sure you have authorized your account with twitter first (by clicking on twitter icon), only valid twitter identites are allowed
        @identity = Identity.new(:identifiable => @virtual_user,
                                 :identity => 'notreal',
                                 :identity_type => 'twitter')
        @identity.save(:validate => false)
        @valid_params = {:identity => '@notreal'}
      end

      it 'should create a virtual merge' do
        lambda{
          post :create,  @valid_params 
        }.should change(VirtualMerge, :count).by(1)
      end

      it 'should set the flash for twitter identity' do
        post :create,  @valid_params 
        response.should be_redirect
        puts assigns[:merge].errors.inspect
        flash[:notice].should eq('Message has been sent. For further instructions, please check email address associated with your merge account')
      end
    end
    
  end

  describe 'completing a merge' do

  end


end
