require 'spec_helper'

describe Merge do


  let(:user)     { User.new(:email => 'some@email.com', :id => 1)}

  let(:identity) { Identity.create(:user          => user,
                                 :identity      => "some identity",
                                 :identity_type => "twitter",
                                 :id            => rand(100), :user_id => 1 )}

  let(:new_user) { User.new(:id => rand(100)) }  

  it 'should be able to merge accounts if passed valid user and valid identity' do
    Merge.should respond_to 'accounts'
    
    result = Merge.accounts new_user, identity
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


  context 'merge instance' do
    let(:merge) { Merge.new}

    it 'should be able to change email_confirmed attribute' do
      merge.should respond_to 'confim!'
      merge.confirmed.should be_false
      merge.confirm!
      merge.confirmed.should be_true
    end
  end


end
