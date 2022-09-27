Rails.application.routes.draw do
  resources :users do
    get 'edit_password', on: :collection
    get 'user-detail' => :forgot_password, on: :collection
    get 'user-forgot-password-mail-sent' => :forgot_password_mail_sent, on: :collection
    # get 'verify/:verification_token', on: :collection, action: :verify
    patch 'set-new-password/:id' => :update
  end

  controller :verification do
    get 'verify/:verification_token' => :verify, as: :verify_user
  end

  controller :registration do
    get 'sign-up' => :new
    post 'sign-up' => :create
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  resources :deals
end
