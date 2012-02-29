module ActionDispatch::Routing
   class RouteSet #:nodoc:
     Mapper.class_eval do
       def authlogic_cas_routes
         Rails.application.routes.draw do
           scope :module => :authlogic do
             scope :module => :cas do
               match "cas_client/service" => "cas_client#service",        :via => :get,  :as => "cas_service"
               match "cas_client/service" => "cas_client#single_signout", :via => :post, :as => "cas_single_signout" 
             end
           end
         end
       end
     end
   end
 end
