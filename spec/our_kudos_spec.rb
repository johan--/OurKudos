require 'spec_helper'

describe OurKudos::Client do
    context "#initialize" do
      it "returns OurKudos::Client instance" do
        instance = OurKudos::Client.new
        instance.should be_a(OurKudos::Client)
      end
    end
    
    context "given an instance" do
      let(:client) { OurKudos::Client.new }



    end
    
  end
  

    