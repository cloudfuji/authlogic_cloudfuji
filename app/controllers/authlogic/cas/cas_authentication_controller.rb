module Authlogic
  module Cas
    class CasAuthenticationController < ::ApplicationController
      include ::Authlogic::Cas::ControllerActions::Session
    end
  end
end
