require 'spec_helper'

describe OurKudos::OkGeo do 

  describe "calling okgeo service" do

    def call_okgeo
       OurKudos::OkGeo.find_local_zip_codes("54701") 
    end

    def call_bad_zip
       OurKudos::OkGeo.find_local_zip_codes("54700") 
    end

    it "should get successfully call okgeo service" do
      call_okgeo
    end

    it "should return 10 closest zip codes" do
      zip_codes = call_okgeo
      zip_codes.size.should == 10
    end

    it "should return blank if bad zipcode" do
      zip_codes = call_bad_zip
      zip_codes.empty?.should == true
    end

  end

end
