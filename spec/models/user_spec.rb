require 'spec_helper'

 describe User, "class" do
   it 'should know about all models allowed to merge account from acts_as_mergeable plugin' do
     
      User.mergeables.should == OurKudos::Acts::Mergeable.mergeables
    
   end  
 end


describe User do

  context 'given an instance' do 
      let(:user) { User.new(:first_name =>"marcin", :last_name => "Walczak") }
  
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
      user.to_s.include?("marcin").should be_true 
      user.to_s.include?("Walczak").should be_true
    end
    
    it 'should be able to set user attributes from session data' do
      u = User.new
      u.apply_omniauth(omniauth)
      u.first_name.should == 'Marcin'
      u.last_name.should == 'Walczak'
      u.email.should == 'marcin.walczak@gmail.com'
      authentication = u.authentications.first
      authentication.should_not be_blank
      authentication.token.should == 'facebook token'
      authentication.uid.should == '12345'
      authentication.provider.should == 'facebook'
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
      user.role_ids = [Factory(:role)]
      user.assign_roles
      user.roles.first.name.should be_an_instance_of String
    end

    it 'should display all roles separated by comma' do
      user.roles << [Factory(:role), Factory(:role)]
      user.render_roles.should be_an_instance_of String
      user.render_roles.include?(",").should be_true if user.roles.size > 1
    end

    it 'should save new identity right after saving in database ' do
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
      user.primary_identity_changed.should be_false
      user.email = 'another-email@emails.com'
      user.primary_identity_changed.should be_true
    end

    it "'should give away all its mergeable data to other user" do
      new_user     = Factory(:user)
      user         = Factory(:user)
      identity = Factory(:identity)
      authentication = Factory(:authentication)

      user.identities << identity
      user.authentications << authentication     

      identity.user_id.should == user.id
      authentication.user_id.should == user.id

      user.give_mergeables_to new_user
      
      identity.user_id.should == new_user.id
      authentication.user_id.should == new_user.id

    end

    it 'should be able to mark its identities as destroyable' do
      some_user = Factory(:user)

      some_user.identities.first.destroy.should be_false

      some_user.set_identities_as_destroyable

      some_user.identities.each { |id| id.destroy.should be_true }

    end

  describe User, "validations" do
    User.new(:first_name => "some name", :last_name => "last name", :email => "email")

    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:password) }    
  end
    
    
  end  
  
  

end
