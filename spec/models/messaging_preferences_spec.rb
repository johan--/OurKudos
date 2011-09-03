require 'spec_helper'

describe MessagingPreference do
  before(:each) do
    @user = Factory(:user)
  end

  it "should default system kudo email to true" do
    @user.messaging_preference.system_kudo_email.should be(true)
  end

  it "should default weekly local summary to true" do
    @user.messaging_preference.weekly_local_summary.should be(true)
  end

  it "should be able to update system kudo email preference" do
    @user.messaging_preference.update_attribute('system_kudo_email', false)
    @user.messaging_preference.system_kudo_email.should be(false)
  end

  it "should be able to update weekly local summary preference" do
    @user.messaging_preference.update_attribute('weekly_local_summary', false)
    @user.messaging_preference.weekly_local_summary.should be(false)
  end

end
