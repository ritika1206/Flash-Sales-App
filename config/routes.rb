Rails.application.routes.draw do
  resources :users

  controller :verification do
    get 'verify/:verification_token' => :verify, as: :verify_user
  end

  controller :registration do
    get 'sign-up' => :new
    post 'sign-up' => :create
  end

  resource :password, only: [:new, :edit, :update] do
    get 'user-forgot-password-mail-sent' => :forgot_password_verify_email, as: :verify_email_for_forgot
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    get 'logout' => :destroy
  end

  namespace :admin do
    resources :deals
  end

  resources :deals, only: [:index, :show]
end
