require 'spec_helper'

describe Authentication do
  
  it 'should be able to get all its types' do
    Authentication.should respond_to 'options_for_provider'
    Authentication.options_for_provider.should be_an_instance_of Array
    Authentication.options_for_provider.first.should be_an_instance_of Array
  end

   context 'given an instance' do

    let(:auth) { Authentication.new }

    it 'should be invalid without provider type, uid, or token' do
     auth.valid?.should be_false
    end

    it 'should be valid with provider type, uid, and token' do
     auth.token    = 'some token'
     auth.uid      = 'some uid'
     auth.provider = 'some provider'
     auth.valid?.should be_true
    end

    it 'should  know its type based on all types' do
      providers = Authentication.options_for_provider.map(&:last)
      providers.each do |provider|
        auth.should respond_to "#{provider}?"
      end
    end


   end
end
