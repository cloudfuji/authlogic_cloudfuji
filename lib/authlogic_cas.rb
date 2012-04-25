require 'rails'
require 'rubycas-client'
require 'authlogic/random'
require 'authlogic_cas/engine'
require 'authlogic_cas/rails_routes'
require 'authlogic_cas/single_sign_out/cache'
require 'authlogic_cas/controller_actions/service'
require 'authlogic_cas/controller_actions/session'


module Authlogic
  module Cas

    @@cas_base_url = "https://cloudfuji.com/cas"

    # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
    @@cas_login_url = nil

    # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
    @@cas_logout_url = nil

    # The login URL of the CAS server.  If undefined, will default based on cas_base_url.
    @@cas_validate_url = nil

    # Should devise_cas_authenticatable enable single-sign-out? Requires use of a supported
    # session_store. Currently supports active_record or redis.
    # False by default.
    @@cas_enable_single_sign_out = true

    # Should devise_cas_authenticatable attempt to create new user records for
    # unknown usernames?  True by default.
    @@cas_create_user = true

    # The model attribute used for query conditions. Should be the same as
    # the rubycas-server username_column. :username by default
    @@cas_username_column = :ido_id

    # Name of the parameter passed in the logout query
    @@cas_destination_logout_param_name = nil
    
    mattr_accessor(
      :cas_base_url,
      :authentication_model,
      :actor_model,
      :cas_login_url,
      :cas_logout_url,
      :cas_validate_url,
      :cas_create_user,
      :cas_destination_logout_param_name,
      :cas_username_column,
      :cas_enable_single_sign_out)


    class << self
    
      def cas_client
        @@cas_client ||= ::CASClient::Client.new(
          :cas_destination_logout_param_name => @@cas_destination_logout_param_name,
          :cas_base_url => @@cas_base_url,
          :login_url => @@cas_login_url,
          :logout_url => @@cas_logout_url,
          :validate_url => @@cas_validate_url,
          :enable_single_sign_out => @@cas_enable_single_sign_out
          )
      end
      

      def setup_authentication
        define_authentication_method_for Authlogic::Cas.actor_model
      end


      def define_authentication_method_for(model)
        model.instance_eval do
          define_singleton_method :authenticate_with_cas_ticket do |ticket|
            ::Authlogic::Cas.cas_client.validate_service_ticket(ticket) unless ticket.has_been_validated?
            return nil if not ticket.is_valid?

            conditions = {::Authlogic::Cas.cas_username_column => ticket.respond_to?(:user) ? ticket.user : ticket.response.user}
            resource   = find(:first, :conditions => conditions)

            resource = new(conditions.merge({:persistence_token => ::Authlogic::Random.hex_token})) if (resource.nil? and ::Authlogic::Cas.cas_create_user?)

            return nil if not resource

            if resource.respond_to? :cloudfuji_extra_attributes
              extra_attributes = ticket.respond_to?(:extra_attributes) ? ticket.extra_attributes : ticket.response.extra_attributes
              resource.cloudfuji_extra_attributes(extra_attributes)
            end

            resource.save
            resource
          end

        end
      end

      def cas_create_user?
        cas_create_user
      end

    end
  end
end
