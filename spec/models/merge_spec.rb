require 'spec_helper'

describe Merge do

  before :each do 
    let(:user)     { User.new(:email => 'some@email.com', :id => 1)}
    let(:identity) { Identity.new(:user => user, :id => rand(100), :user_id => 1 )}
    let(:new_user) { User.new(:id => rand(100)) }
  end

  it 'should be able to merge accounts if given user and valid identity' do
    Merge.should respond_to 'accounts'
    result = Merge.accounts new_user, identity
    result.should be_an_instance_of Merge
  end


  context 'merge instance' do
    let(:merge) { Merge.new}

    it 'should be able to change email_confirmed attribute' do
      merge.should respond_to 'set_as_confirmed!'
      merge.email_confirmed.should be_false
      merge.set_as_confirmed!
      merge.email_confirmed.should be_true
    end
  end


end
