require "spec_helper"

describe "Authlogic::Cas::ControllerActions::Session" do
  subject { Authlogic::Cas::ControllerActions::Session }

  describe "new_cas_session" do
    it "should redirect to the cas_login_url if the user is not returning after CAS login" do
      pending
    end
  end

  describe "returning_from_cas?" do
    it  "should return true if returning from CAS server" do
      pending
    end

    it "should return nil if not returning from CAS" do
      pending
    end
  end

  describe "cas_login_url" do
    it "should return the CAS url to redirect user for authentication" do
      pending
    end

    it "should contain a redirect parameter specifying the url to redirect the user to post-login" do
      pending
    end
  end
end

