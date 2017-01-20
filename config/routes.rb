Rails.application.routes.draw do
  devise_for :users

  scope :path => '/api/v1/', :module => "api_v1", :as => 'v1', :defaults => { :format => :json } do
    resources :events, only: [:create]
  end

  resources :events do
    collection do
      get :calendar
      get :ics_export
      get :my_ics_export
    end
  end

  resources :week_tables

  root 'events#index'
end
