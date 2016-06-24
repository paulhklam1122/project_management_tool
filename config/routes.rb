Rails.application.routes.draw do
  root "home#index"
  get "/about" => "home#about"

  resources :users, only:[:new, :create, :edit, :update]
  resource :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  get "/changepassword" => "users#change_password", as: :change_password
  patch "/changepassword" => "users#update_password"

  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :projects do
    resources :discussions do
      resources :comments
    end#, shallow: true
    resources :favourites, only:[:create, :destroy]
    resources :tasks
    post "/tasks/:id" => "tasks#mark", as: :mark
    get :search, on: :collection
    post :flag, on: :member
    post :mark_done
    resources :teams
  end
  resources :favourites, only:[:index]
end
