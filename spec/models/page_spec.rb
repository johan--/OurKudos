require 'spec_helper'

describe Page do
  context "page class" do

    it 'should be able to find given page by locale' do
      Page.should.respond_to?("find_by_locale?")
    end

    it 'should know about all its slugs' do
      Page::SLUGS.should be_an_instance_of Hash
    end

    it 'should store all slug intsoances under seed method' do
      Page.should.respond_to?("seed")
      Page.seed!.size.should == Page::SLUGS.size
    end


  end
end
