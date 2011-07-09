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

  context "auto retrieving fields" do
    
    before(:each) do 
      @gift = Gift.create!(:merchant_id => Factory(:retreivable_merchant).id, 
                          :affiliate_code => "OSF33D707")
    end

    describe "on create" do

      it "should auto retrieve name" do
        @gift.name.should == "Miniature Tuscan Olive Tree"
      end

      it "should auto retrieve link" do
        @gift.link.should == "http://www.kqzyfj.com/click-5253557-10466771?url=http%3A%2F%2Fwww.organicbouquet.com%2Fp_707%2FVeriFlora-Certified%2FFlowers%2FPlants-and-Seeds%2FMiniature-Olive-Tree.html%3FsubCatId%3D160%26utm_source%3Dcj%26utm_medium%3Daffiliate%26utm_campaign%3Dcj%26src%3DCJOB&cjsku=OSF33D707"
      end

      it "should auto retrieve price" do
        @gift.price.should == 75.95
      end

      it "should auto retrieve description" do
        @gift.description.should == "Our VeriFlora certified Miniature Tuscan Olive Tree brings the warm winds of the Mediterranean into your home or garden. It grows best outdoors, on a patio, in bright sun and moderate temperatures."
      end

    end

    describe "updating from auto retrieve" do
      before(:each) do 
        @gift.update_attributes('price' => 1, 
                                'link' => "www.resetlink.com",
                                'description' => "make sure this is not overwritten")
        @gift.save
        @gift.update_commission_junction
      end

      it "should update price" do
        @gift.price.should == 75.95
      end

      it "should update link" do
        @gift.link.should == "http://www.kqzyfj.com/click-5253557-10466771?url=http%3A%2F%2Fwww.organicbouquet.com%2Fp_707%2FVeriFlora-Certified%2FFlowers%2FPlants-and-Seeds%2FMiniature-Olive-Tree.html%3FsubCatId%3D160%26utm_source%3Dcj%26utm_medium%3Daffiliate%26utm_campaign%3Dcj%26src%3DCJOB&cjsku=OSF33D707"
      end

      it "should not update description" do
        @gift.description.should_not == "Our VeriFlora certified Miniature Tuscan Olive Tree brings the warm winds of the Mediterranean into your home or garden. It grows best outdoors, on a patio, in bright sun and moderate temperatures."
      end

    end

  end

end
