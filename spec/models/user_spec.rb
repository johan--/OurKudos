require 'spec_helper'

describe User do
  before(:all) do
    Settings.seed!
  end

  context 'given an instance' do 
      let(:user) { Factory(:user) }

      let(:omniauth) do
          {"provider"  => "facebook",
          "uid"       => '12345',
          "user_info" => {
            "email" => "marcin.walczak@gmail.com",
            "first_name" => "Marcin",
            "last_name"  => "Walczak",
            "name"       => "Marcin Walczak"
          },
          'credentials'=> {
            'token' => 'facebook token'
          }
        }
      end
    
    it 'should be able to return first and last name' do
      user.should respond_to 'to_s' 
      user.to_s.include?(user.first_name).should be_true
      user.to_s.include?(user.last_name).should be_true
    end
    
    it 'should be able to set user attributes from session data' do
      u = User.new
      u.apply_omniauth omniauth
      u.first_name.should == omniauth['user_info']['first_name']
      u.last_name.should  == omniauth['user_info']['last_name']
      u.email.should      == omniauth['user_info']['email']
      authentication = u.authentications.first
      authentication.should_not be_blank
      authentication.token.should    == omniauth['credentials']['token']
      authentication.uid.should      == omniauth['uid']
      authentication.provider.should == omniauth['provider']
    end

    it 'should know about its roles' do
      user.should.respond_to? "has_role?"
      user.has_role?(:admin).should be_false
      user.roles << Role.create(:name => "admin")
      user.has_role?(:admin).should be_true
    end

    it 'should be able to set its roles based on roles ids attribute' do
      user.role_ids = []
      user.assign_roles
      user.roles.should be_blank
      user.role_ids = [Factory(:role).id]
      user.assign_roles
      user.roles.first.name.should be_an_instance_of String
    end

    it 'should display all roles separated by comma' do
      user.roles << [Factory(:role), Factory(:role)]
      user.render_roles.should be_an_instance_of String
      user.render_roles.include?(",").should be_true if user.roles.size > 1
    end

    it 'should save new identity right after confirming it ' do
     user = Factory(:user)
     user.primary_identity.should_not be_blank
     user.primary_identity.identity.should == user.email
    end

    it 'should update primary identity right after its email changed' do
      user = Factory(:user)
      user.primary_identity.identity == user.email
      user.email = 'some-new@email.com'
      user.save
      user.primary_identity.identity == user.email
    end

    it 'should know if its email has changed' do
      user = Factory(:user)
      user.email = 'another-email@emails.com'
      user.primary_identity_changed.should be_true
    end

    it 'should be able to mark its identities as destroyable' do
      some_user = Factory(:user)

      some_user.identities.first.destroy.should be_false

      some_user.set_identities_as_destroyable

      #Identity.for(some_user).each { |id| id.destroy.should be_true }
      some_user.identities.each { |id| id.destroy.should be_true }

    end

    it 'should include user name in request param id' do
      user = Factory(:user)

      user.to_param.include?(user.id.to_s).should be_true
      user.to_param.include?(user.first_name.gsub(" ",'-')).should be_true

    end

    it 'should know whether its a company or not' do
      user = Factory(:user)
      user.should.respond_to?("company?")
    end


  describe User, "validations" do
    User.new(:first_name => "some name 323", :last_name => rand(100), :email => "email@com.pl")

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }    
  end
    
    
  end  
  
  context "the users dashboard" do
    describe User, "local kudos tab" do
      before(:each) do 
        @user1 = Factory(:user, :postal_code => '54701')
        @user2 = Factory(:user, :postal_code => '54720')
        @kudo = Factory(:kudo, :to => @user2.identities.first.id.to_s)
      end

      it "should respond to local_kudos" do
        @user1.should respond_to('local_kudos')
      end

      it "should return @user2 as a local user for @user1" do
        local_users = User.local_users(@user1).split(",")
        local_users.should include(@user2.id.to_s)
      end

      it "should return include kudos from local zips codes" do
        @user1.local_kudos.should include(@kudo)
      end

      it "should be an ActiveRecord::Relation" do
        @user1.local_kudos.should be_an(ActiveRecord::Relation)
      end

    end
  end

  describe 'messaging preferences' do
    it "should create a messaging preference for a new user" do
      user = Factory(:user)
      user.messaging_preference.system_kudo_email.should eq(true)
                                         
    end
  end

  describe 'User methods and attributes' do
    before(:each) do
      @user = Factory(:user, :first_name => "Steve", :last_name => 'Woz')
    end

    it 'should return a secured name when no display identity' do
      identity = @user.identities.first
      identity.update_attribute('display_identity', false)
      @user.secured_name.should eq('Steve W.')
    end
  end
  
end
