require File.expand_path('../../spec/spec_helper', __FILE__)


describe "Acts As Mergeable" do


  before(:each) do
    clean_database!
  end


  it "should provide a class method 'is_mergeable?' that is false for unmergeable models" do
    MergeableModel.is_mergeable?.should be_true
    NotMergeableModel.is_mergeable?.should be_false
  end

  it 'should know all mergeable models' do
     OurKudos::Acts::Mergeable.should respond_to(:mergeables)
     OurKudos::Acts::Mergeable.mergeables.include?(MergeableModel).should be_true
  end

  it 'should be able to assign mergeable to other user' do
    old_user        = User.new :id => 1, :name => "hey"
    mergeable_model = MergeableModel.new(:name => "some model")

    old_user.mergeable_models << mergeable_model

    mergeable_model.user_id.should == old_user.id

    mergeable_model.should respond_to :change_owner_to

  end



end
