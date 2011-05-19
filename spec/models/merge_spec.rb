require 'spec_helper'

describe Merge do


  let(:user)     { User.new(:email => 'some@email.com', :id => 1)}

  let(:identity) { Factory(:identity) }

  let(:new_user) { Factory(:user) }

  it 'should be able to merge accounts if passed valid user and valid identity' do
    Merge.should respond_to 'accounts'
    
    result = Merge.accounts new_user, identity
    result.password = identity.user.password
    
    result.identity.stub!(:mergeable?).and_return(true)
    
    result.should be_an_instance_of Merge

    result.save.should be_true
    result.should be_persisted
  end

  it 'should return an invalid merge object if passed an empty identity' do
    result = Merge.accounts new_user, nil
    result.valid?.should be_false
    result.save.should be_false    
  end

 

end
