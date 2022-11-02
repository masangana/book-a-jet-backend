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
      
      #For reservations CRUD
      get '/reservations', to: 'reservations#index'
      get '/reservations/:id', to: 'reservations#show'
      post '/add_reservation', to: 'reservations#create'
      delete '/del_reservation', to: 'reservations#destroy'

      #For jets CRUD
      post '/add-jet', to: 'jets#create'
      delete '/delete-jet', to: 'jets#destroy'
      patch '/update-jet', to: 'jets#update'
      get '/jets', to: 'jets#index'
      get '/jets/:id', to: 'jets#show'
     #show authorizeduser info
     get "/authenticated-user", to: "auths#show"
    end
  end

end
