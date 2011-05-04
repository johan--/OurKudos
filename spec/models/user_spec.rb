require 'spec_helper'

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
    
    
    
  end  
  
  

end
