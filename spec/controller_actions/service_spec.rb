require "spec_helper"

describe "Authlogic::Cas::ControllerActions::Service" do

  describe "GET service" do
    it "should authenticate the user" do
      pending
    end
  end

  describe "POST service" do
    it "should signout the user if a valid service ticket was passed" do
      pending
    end
    
    it "should signout the user if the unique_cas_id is valid user of the app" do
      pending
    end
  end

  describe "update_persistence_token_for" do
    it "should update the persistence token for the user with the specified unique CAS ID" do
      pending
    end
  end

  describe "ticket_from" do
    it "should create a ticket object from the specified ticket name" do
      pending
    end
  end

  describe "read_service_ticket_from" do
    it "should read the service ticket from the POST data" do
      pending
    end
  end
end
