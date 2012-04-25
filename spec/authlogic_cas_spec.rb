require 'spec_helper'

describe "Authlogic::Cas" do

  subject { ::Authlogic::Cas }

  before :all do
    ActorExample = Class.new
    subject.actor_model = ActorExample
  end
  
  it "should have methods to set actor_model and the authentication_model" do
    subject.respond_to?(:actor_model).should be_true
    subject.respond_to?(:actor_model=).should be_true
    subject.respond_to?(:authentication_model).should be_true
    subject.respond_to?(:authentication_model=).should be_true
  end
  
  describe "defaults" do
    it "should have the Cloudfuji CAS server as the default" do
      subject.cas_base_url.should == "https://cloudfuji.com/cas"
    end

    it "should have cas_create_user set to true" do
      subject.cas_create_user.should be_true
    end

    it "should have single signout enabled" do
      subject.cas_enable_single_sign_out.should be_true
    end

    it "should have cas_username_column set to ido_id" do
      subject.cas_username_column.should == :ido_id
    end
  end

  
  describe "cas_client" do
    it "should return an instance of CASClient" do
      subject.cas_client.should be_kind_of(::CASClient::Client)
    end
  end

  
  describe "setup_authentication" do
    it "should define authentication method for the actor model" do
      subject.should_receive(:define_authentication_method_for).with(subject.actor_model)
      subject.setup_authentication
    end
  end

  
  describe "define_authentication_method_for" do
    it "should define the authentication_with_cas_ticket method on the specified model" do
      ActorExample.respond_to?(:authenticate_with_cas_ticket).should be_false
      
      subject.define_authentication_method_for(ActorExample)
      ActorExample.respond_to?(:authenticate_with_cas_ticket).should be_true
    end
  end

  describe "authenticate_with_cas_ticket" do
    before :all do
      subject.define_authentication_method_for(ActorExample)
    end

    before :each do
      @example_ticket = double ::CASClient::ServiceTicket
    end
    
    it "should check if a ticket has been validated" do
      @example_ticket.stub!(:has_been_validated?).and_return(true)
      @example_ticket.stub!(:is_valid?).and_return(false)
      
      ActorExample.authenticate_with_cas_ticket(@example_ticket)
    end

    it "should validate ticket if it has not been validated" do
      @example_ticket.stub!(:has_been_validated?).and_return(false)
      @example_ticket.stub!(:is_valid?).and_return(false)

      subject.cas_client.should_receive(:validate_service_ticket).with(@example_ticket)
      ActorExample.authenticate_with_cas_ticket(@example_ticket)
    end

    it "should return nil if the ticket is not valid" do
      @example_ticket.stub!(:has_been_validated?).and_return(true)
      @example_ticket.stub!(:is_valid?).and_return(false)

      ActorExample.authenticate_with_cas_ticket(@example_ticket).should be_nil
    end

    it "should try to find the user and create a session for the user" do
      @example_user = ActorExample.new
      @example_user.stub!(:save)

      @example_ticket.stub!(:has_been_validated?).and_return(true)
      @example_ticket.stub!(:is_valid?).and_return(true)
      @example_ticket.stub!(:user).and_return("example_unique_user_id")
      
      
      ActorExample.stub!(:find).and_return(@example_user)

      ActorExample.authenticate_with_cas_ticket(@example_ticket).should == @example_user
    end

    it "should create a new user incase the user with the unique CAS ID isn't found" do
      @example_user = ActorExample.new
      @example_user.stub!(:save)

      @example_ticket.stub!(:has_been_validated?).and_return(true)
      @example_ticket.stub!(:is_valid?).and_return(true)
      @example_ticket.stub!(:user).and_return("example_unique_user_id")
      
      ActorExample.should_receive(:find).and_return(nil)
      ActorExample.should_receive(:new).and_return(@example_user)      

      ActorExample.authenticate_with_cas_ticket(@example_ticket).should == @example_user
    end

    it "should call the cloudfuji_extra_attributes method on the actor model if defined" do
      @example_user = ActorExample.new
      @example_user.stub!(:save)
      @example_user.stub!(:cloudfuji_extra_attributes)
      
      @example_ticket.stub!(:has_been_validated?).and_return(true)
      @example_ticket.stub!(:is_valid?).and_return(true)
      @example_ticket.stub!(:user).and_return("example_unique_user_id")
      @example_ticket.stub!(:extra_attributes).and_return({})
      ActorExample.stub!(:find).and_return(@example_user)

      @example_user.should_receive(:cloudfuji_extra_attributes)

      ActorExample.authenticate_with_cas_ticket(@example_ticket).should == @example_user
    end
  end

  describe "cas_create_user?" do
    it "should return true if @@cas_create_user is true" do
      subject.cas_create_user = true
      subject.cas_create_user?.should be_true
    end

    it "should return true if @@cas_create_user is false" do
      subject.cas_create_user = false
      subject.cas_create_user?.should be_false
    end
  end
  
end
