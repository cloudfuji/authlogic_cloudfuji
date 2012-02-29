module Authlogic
  module Cas
    class CasAuthenticationController
      include ::Authlogic::Cas::ControllerActions::Session
    end
  end
end