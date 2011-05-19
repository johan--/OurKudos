require 'spec_helper'
describe AuthenticationObserver do

   before :each do
    @authentication = Factory(:authentication)
    @observer       =  AuthenticationObserver.instance
   end

  it "should invoke after_save on the observed object" do
     @authentication.should_receive(:twitter?)
     @observer.after_save @authentication
  end

end

