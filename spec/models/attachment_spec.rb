require 'spec_helper'

describe Attachment do
  before :all do
    Settings.seed!
  end

  describe 'a new instance' do
  
    describe 'a valid attachment' do
      before(:each) do
        @attachment = Attachment.new(:name => 'testimg',
                                    :attachment => File.new(Rails.root + 'features/assets/HappyChrismah.gif'))
      end

      it 'should be valid' do
        @attachment.valid?.should be_true
      end

      it 'should create the attachment' do
        @attachment.save.should be_true
      end

    end

    describe 'an invalid attachment' do
      before(:each) do
        @attachment = Attachment.new(:name => 'testimg')
      end

      it 'should not be valid' do
        @attachment.valid?.should be_false
      end
      
      it 'should not create the attachment' do
        @attachment.save.should be_false
      end

    end
  end

  describe 'an instance of attachment' do
    before(:each) do
      @attachment = Attachment.create(:name => 'testimg..',
      :attachment => File.new(Rails.root + 'features/assets/HappyChrismah.gif'))
    end

    it 'should respond to to_param' do
      @attachment.to_param.should eq("#{@attachment.id}-testimg")
    end

    it 'should respond to file_path' do
      @attachment.file_path.should eq("#{Rails.root}/public/system/attachments/#{@attachment.id}/original/HappyChrismah.gif")
    end

    it 'should respond to image_path' do
      @attachment.image_path.should eq("http://ourkudos.com/system/attachments/#{@attachment.id}/original/HappyChrismah.gif")
    end

    it 'should respond to kudo_link' do
      @attachment.kudo_link.should eq("http://ourkudos.com/cards/#{@attachment.id}")
    end
  end
  
end
