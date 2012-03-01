require "spec_helper"

describe Authlogic::Cas::CasClientController do

  before :all do
    @ticket_name = "abc123"
    @user = Authlogic::Cas.actor_model.new
    @unique_cas_id = "xyz123"
  end
  
  describe "GET service" do
    it "should authenticate the user" do
      Authlogic::Cas.actor_model.should_receive(:authenticate_with_cas_ticket).with(instance_of(::CASClient::ServiceTicket))
      get 'service', {:ticket => @ticket_name}
    end

    it "should create a session for the user if on successful authentication" do
      
      AuthTestModel = Class.new
      AuthTestModel.stub!(:create)
      Authlogic::Cas.authentication_model = AuthTestModel
      
      ticket = double ::CASClient::ServiceTicket      
      ticket.stub!(:user).and_return(@unique_cas_id)
      ticket.stub!(:ticket).and_return(@ticket_name)
      controller.stub!(:ticket_from).and_return(ticket)
      
      Authlogic::Cas.actor_model.should_receive(:authenticate_with_cas_ticket).with(ticket).and_return(@user)

      Authlogic::Cas.
        authentication_model.
        should_receive(:create).
        with(@user)
      
      get 'service', {:ticket => @ticket_name}
    end
  end

  describe "POST service" do
    it "should signout the user if a valid service ticket was passed" do
      ::Authlogic::Cas::SingleSignOut::Cache.
        should_receive(:find_unique_cas_id_by_service_ticket).
        and_return(@unique_cas_id)

      controller.should_receive(:update_persistence_token_for).with(@unique_cas_id)
      post 'single_signout', {
        'logoutRequest' => "<samlp:LogoutRequest><samlp:SessionIndex>#{@ticket_name}</samlp:SessionIndex></samlp:LogoutRequest>"
      }
    end
  end
end
