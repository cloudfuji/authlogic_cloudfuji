require "spec_helper"

describe "Authlogic::Cas::SingleSignOut::Cache" do

  subject { Authlogic::Cas::SingleSignOut::Cache }
  
  describe "class methods" do
    before :each do
      @service_ticket_name = "1234"
      Rails.stub!(:cache).and_return(ActiveSupport::Cache::Store.new)
      Rails.stub!(:logger).and_return(ActiveSupport::BufferedLogger.new($stdout))
    end
    
    describe "logger" do
      it "should return a rails logger object" do
        ::Rails.should_receive(:logger)
        subject.logger
      end
    end

    describe "delete_service_ticket" do
      it "deletes the service ticket from the Rails cache" do
        ::Rails.cache.should_receive(:delete).with(subject.send(:cache_key, @service_ticket_name))
        subject.delete_service_ticket(@service_ticket_name)
      end
    end

    describe "find_unique_cas_id_by_service_ticket" do
      it "should find the unique CAS ID by service ticket" do
        unique_cas_id = "abc123"
        ::Rails.cache.stub!(:read).and_return(unique_cas_id)

        subject.find_unique_cas_id_by_service_ticket(@service_ticket).should == unique_cas_id
      end
    end

    describe "store_unique_cas_id_for_service_ticket" do
    end

    describe "cache_key" do
      it "should return the name of the key with a authlogic_cas prefix" do
        subject.send(:cache_key, @session_index).should == "authlogic_cas:#{@session_index}"
      end
    end
  end
  
end
