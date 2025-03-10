Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  defaults format: :json do
    namespace :api do
      namespace :v1 do
        namespace :authentication do
          resources :login, only: :create
          resources :register, only: :create
        end

        resources :translate_text, only: :create
        resources :languages, only: :index
      end
    end

    get "/" => "api/v1/main#index", as: :main, only: :index
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
