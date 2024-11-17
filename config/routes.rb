Rails.application.routes.draw do
  root 'home#index'
  get '*path', to: 'home#index', constraints: ->(request) do
    !request.xhr? && request.format.html?
  end

  # get 'signup', to: 'users#new'
  # resources :users, except: [:new]

  namespace :v1 do
    resources :users
  end

  #sessionコントローラー
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  #imageコントローラー
  patch "updateImg", to: "images#update"
  #passwordコントローラー
  patch "updatedpassword", to: "password#update"
end
