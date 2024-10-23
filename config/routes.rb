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
end
