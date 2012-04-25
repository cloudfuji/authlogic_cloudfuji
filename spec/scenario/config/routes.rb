Altry::Application.routes.draw do

  scope :module => :authlogic do
    scope :module => :cas do
      match "/login"  => "cas_authentication#new_cloudfuji_session",     :as => "login"
      match "/logout" => "cas_authentication#destroy_cloudfuji_session", :as => "logout"
    end
  end

  resources :users

  root :to => "main#index"
  match "main/index" => "main#index"
  match "main/index2" => "main#another_cool_page"
  
end
