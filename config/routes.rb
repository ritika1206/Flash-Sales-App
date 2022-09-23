Rails.application.routes.draw do
  resources :users
  
  controller :passwords do
    get 'user-email' => :forgot_password
    get 'user-forgot-password-mail-sent' => :forgot_password_verify_email, as: :verify_email_for_forgot_password
    get 'edit_password'
    patch ':user_id/set-new-password' => :set_new_password, as: :set_new_password
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

  namespace :admin do
    resources :deals
  end
end
