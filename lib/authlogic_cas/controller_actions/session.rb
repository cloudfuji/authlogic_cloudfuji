module Authlogic
  module Cas
    module ControllerActions
      module Session

        def new_cas_session
          puts "Trying new user session"
          redirect_to(cas_login_url) unless returning_from_cas?
        end

        def destroy_cas_session
          puts "AUTH MODEL: #{::Authlogic::Cas.authentication_model.inspect}"
          @user_session = ::Authlogic::Cas.authentication_model.find
          @user_session.destroy
          redirect_to ::Authlogic::Cas.cas_client.logout_url
        end

        # protected

        def returning_from_cas?
          puts "REFERER: #{request.referer.inspect} #{params[:ticket].inspect}"
          puts "RETURNING FROM CAS: #{(params[:ticket] || request.referer =~ /^#{::Authlogic::Cas.cas_client.cas_base_url}/).inspect}"
          params[:ticket] || request.referer =~ /^#{::Authlogic::Cas.cas_client.cas_base_url}/
        end


        def cas_login_url
          login_url_from_cas_client = ::Authlogic::Cas.cas_client.add_service_to_login_url(cas_service_url)
          redirect_url = ""# "&redirect=#{cas_return_to_url}"
          puts "redirecting to #{login_url_from_cas_client}#{redirect_url}"
          return "#{login_url_from_cas_client}#{redirect_url}"
        end

      end
    end
  end
end
