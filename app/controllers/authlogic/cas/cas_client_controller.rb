module Authlogic
  module Cas
    class CasClientController < ::ApplicationController
      include ::Authlogic::Cas::ControllerActions::Service
    end
  end
end
