Rails.application.routes.draw do
  resources :users do
    get 'verify/:verification_token', on: :collection, action: :verify
  end

  controller :sessions do
    get 'login' => :new, as: :login
    post 'login' => :create
  end

  resources :deals
end
