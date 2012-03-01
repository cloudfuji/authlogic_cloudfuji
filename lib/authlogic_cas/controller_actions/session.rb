module Authlogic
  module Cas
    module ControllerActions
      module Session

        def new_cas_session
          redirect_to(cas_login_url) unless returning_from_cas?
        end

        def destroy_cas_session
          @user_session = ::Authlogic::Cas.authentication_model.find
          @user_session.destroy if @user_session
          redirect_to ::Authlogic::Cas.cas_client.logout_url
        end

        protected

        def returning_from_cas?
          params[:ticket] || request.referer =~ /^#{::Authlogic::Cas.cas_client.cas_base_url}/
        end


        def cas_login_url
          login_url_from_cas_client = ::Authlogic::Cas.cas_client.add_service_to_login_url(cas_service_url)
          redirect_url = ""# "&redirect=#{cas_return_to_url}"
          return "#{login_url_from_cas_client}#{redirect_url}"
        end

      end
    end
  end
end
