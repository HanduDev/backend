Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  mount ActionCable.server => '/cable'

  defaults format: :json do
    namespace :api do
      namespace :v1 do
        namespace :authentication do
          resources :login, only: :create
          resources :register, only: :create
          resources :google, only: :create
        end

        namespace :users do
          resources :confirm_email, only: :create
          resources :resend_email_confirmation, only: :create
          resource :me, only: [:show, :update	], controller: 'me'
        end

        resources :translate_text, only: :create
        resources :languages, only: :index
        resources :trails, only: [:index, :show, :destroy, :create] do
          collection do
            resources :check_answer, only: :update, module: :trails
          end
        end
        resources :lessons, only: [:index, :show, :destroy, :update]
      end
    end

    get "/" => "api/v1/main#index", as: :main, only: :index
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
