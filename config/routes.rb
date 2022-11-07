Rails.application.routes.draw do


  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  scope module: 'api', path: "api" do 

  scope :v1 do 
    devise_for :users, path: '', path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "signup"
      },
      controllers: {
        sessions: "api/v1/sessions",
        registrations: "api/v1/registrations"
      }
    end
  end

  root 'homes#index'
  namespace :api do
    namespace :v1 do
      
    
      resources :reservations, only: %i[index create show destroy]
      resources :jets, only: %i[index create show  destroy]
   
     get "/authenticated-user", to: "auths#show"
    end
  end

end
