Rails.application.routes.draw do
  resources :users do
    get 'edit_password', on: :collection
    get 'user-detail' => :forgot_password, on: :collection
    get 'user-forgot-password-mail-sent' => :forgot_password_mail_sent, on: :collection
    get 'verify/:verification_token', on: :collection, action: :verify
    patch 'set-new-password/:id' => :update
  end

  controller :sessions do
    get 'login' => :new, as: :login
    post 'login' => :create
  end

  resources :deals
end
