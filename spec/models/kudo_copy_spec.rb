require 'spec_helper'

describe KudoCopy do


  context "intance" do
    let(:kudo_copy) { KudoCopy.new(:recipient => Factory(:user), :kudo => Factory(:kudo)   )}

    it 'should know about its recipient name' do
      kudo_copy.should respond_to "copy_recipient"
      kudo_copy.copy_recipient.should == Factory(:user).to_s

      kudo_copy.recipient = kudo_copy.author

      kudo_copy.copy_recipient.should be_nil
    end

  end


end
