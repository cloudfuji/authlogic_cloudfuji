require "spec_helper"

describe Authlogic::Cas::CasAuthenticationController do

  describe "GET new_cas_session" do
    it "should redirect to the cas_login_url if the user is not returning after CAS login" do
      cas_login_url = controller.send(:cas_login_url)
      
      get 'new_cas_session'
      response.should redirect_to(cas_login_url)
    end
  end

  describe "destroy_cas_session" do
    it "should destroy the user session and redirect to the logout page on the CAS server" do
      AuthSession = Class.new
      
      Authlogic::Cas.authentication_model = AuthSession
      session = Object.new
      AuthSession.should_receive(:find).and_return(session)
      session.should_receive(:destroy)
      
      get 'destroy_cas_session'
    end
  end

  it "should redirect to te CAS logout url once logged out" do
    
  end
end

