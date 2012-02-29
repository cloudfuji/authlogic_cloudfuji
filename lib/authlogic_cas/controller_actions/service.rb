module Authlogic
  module Cas
    module ControllerActions
      module Service
        def service
          cas_scope    = ::Authlogic::Cas.actor_model
          ticket       = ticket_from params
          auth_result  = cas_scope.authenticate_with_cas_ticket(ticket)
          
          (redirect_to(root_path, :notice => "Could not authenticate user") && return) if not auth_result

          if ::Authlogic::Cas.cas_enable_single_sign_out
            unique_cas_id = ticket.respond_to?(:user) ? ticket.user : ticket.response.user
            ::Authlogic::Cas::SingleSignOut::Cache.store_unique_cas_id_for_service_ticket(ticket.ticket, unique_cas_id)
          end

          user_session = Authlogic::Cas.authentication_model.new(auth_result)
          if user_session.save
            redirect_to(root_path)
          else
            redirect_to(root_path, :notice => "Could not login. Try again please.")
          end
        end

        def single_signout
          if ::Authlogic::Cas.cas_enable_single_sign_out
            service_ticket = read_service_ticket_name

            if service_ticket
              logger.info "Intercepted single-sign-out request for CAS session #{service_ticket}."
              ido_id = ::Authlogic::Cas::SingleSignOut::Cache.find_unique_cas_id_by_service_ticket(service_ticket)
              update_persistence_token_for(ido_id)
            end
          else
            logger.warn "Ignoring CAS single-sign-out request as feature is not currently enabled."
          end

          render :nothing => true
        end

        # protected

        def update_persistence_token_for(ido_id)
          user = User.send("find_by_#{::Authlogic::Cas.cas_username_column.to_s}", ido_id)
          user.update_attribute(:persistence_token, ::Authlogic::Random.hex_token) if user
        end
        
        def ticket_from(controller_params)
          ticket_name = controller_params[:ticket]
          return nil unless ticket_name

          service_url = bushido_service_url
          if ticket_name =~ /^PT-/
            ::CASClient::ProxyTicket.new(ticket_name, service_url, controller_params[:renew])
          else
            ::CASClient::ServiceTicket.new(ticket_name, service_url, controller_params[:renew])
          end
        end
        
        def read_service_ticket_name
          if request.headers['CONTENT_TYPE'] =~ %r{^multipart/}
            false
          elsif request.post? && params['logoutRequest'] =~
              %r{^<samlp:LogoutRequest.*?<samlp:SessionIndex>(.*)</samlp:SessionIndex>}m
            $~[1]
          else
            false
          end
        end
      end

    end
  end
end
