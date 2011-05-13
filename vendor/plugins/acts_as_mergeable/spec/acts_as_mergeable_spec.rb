require File.expand_path('../../spec/spec_helper', __FILE__)


describe "Acts As Mergeable" do
    let(:old_user)               { User.new :id => 1, :name => "hey" }
    let(:new_user)               { User.new :id => 2, :name => "hey I'm the new one " }
    let(:mergeable_model)        { MergeableModel.new(:name => "some model")}
    let(:other_mergeable_model)  { OtherMergeableModel.new(:name => "some other model")}

  before(:each) do
    clean_database!    
  end


  it "should provide a class method 'is_mergeable?' that is false for unmergeable models" do
    MergeableModel.is_mergeable?.should be_true
    NotMergeableModel.is_mergeable?.should be_false
  end

  it 'should know about all mergeable models' do
     OurKudos::Acts::Mergeable.should respond_to(:mergeables)
     OurKudos::Acts::Mergeable.mergeables.include?(MergeableModel).should be_true
     OurKudos::Acts::Mergeable.mergeables.include?(NotMergeableModel).should be_false
  end

  it 'should be able to assign mergeable to other user' do
    old_user.mergeable_models << mergeable_model

    mergeable_model.user_id.should == old_user.id

    mergeable_model.should respond_to :change_owner_to

    mergeable_model.change_owner_to new_user

    mergeable_model.user_id.should == new_user.id

  end

   it 'should be able to assign all its mergeables to other user' do

    old_user.mergeable_models << mergeable_model
    old_user.other_mergeable_models << other_mergeable_model

    mergeable_model.user_id.should == old_user.id
    other_mergeable_model.user_id.should == old_user.id

    MergeableModel.should respond_to :change_objects_owner_to

    MergeableModel.change_objects_owner_to old_user.mergeable_models, new_user
    OtherMergeableModel.change_objects_owner_to old_user.other_mergeable_models, new_user
      
    mergeable_model.user_id.should == new_user.id
    other_mergeable_model.user_id.should == new_user.id


   end

end
