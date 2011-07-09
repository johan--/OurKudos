require 'spec_helper'

describe Gift do
  

  context 'given an instance' do 

    let(:gift) { Factory(:gift) }
    let(:retrievable_gift) { Factory(:retrievable_gift)}

    it "should respond to auto_retreivable" do
      gift.should.respond_to? "auto_retrievable?"
      gift.auto_retrievable?.should be_false
    end

    it "should return true if retrivable" do
      retrievable_gift.should.respond_to? "auto_retrievable?"
      retrievable_gift.auto_retrievable?.should be_true
    end

  end

end
