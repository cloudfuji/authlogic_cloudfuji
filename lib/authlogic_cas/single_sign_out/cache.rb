module Authlogic
  module Cas
    module SingleSignOut
      class Cache

        class << self
        
          def logger
            @logger ||= Rails.logger
          end
          
          def delete_service_ticket(service_ticket_name)
            logger.info("Deleting index #{service_ticket_name}")
            Rails.cache.delete(cache_key(service_ticket_name))
          end
          
          def find_unique_cas_id_by_service_ticket(service_ticket_name)
            unique_cas_id = Rails.cache.read(cache_key(service_ticket_name))
            logger.debug("Found session id #{unique_cas_id.inspect} for index #{service_ticket_name.inspect}")
            unique_cas_id
          end
          
          def store_unique_cas_id_for_service_ticket(service_ticket_name, unique_cas_id)
            Rails.cache.write(cache_key(service_ticket_name), unique_cas_id)
          end
          
          protected
          
          def cache_key(service_ticket_name)
            "authlogic_cas:#{service_ticket_name}"
          end

        end
      end
    end
  end
end

