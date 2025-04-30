Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  
  # OpenAPI/Swagger documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  # API routes with version namespace
  namespace :api do
    namespace :v1 do
      # ユーザー関連
      resources :users, only: [:index, :create]
      
      # 都市情報関連
      resources :cities, only: [:index, :create]
      
      # お気に入り都市関連
      resources :favorite_cities, only: [:index, :create] do
        collection do
          delete :destroy
          get :weather
        end
      end
      
      # 天気データ関連
      resources :weather_records, only: [:index, :create] do
        collection do
          post :fetch_current
          get :statistics
        end
      end
    end
  end
end
