Rails.application.routes.draw do
  root "home#index"
  get "/about" => "home#about"

  resources :projects do
    resources :discussions do
      resources :comments
    end#, shallow: true
    resources :tasks
    post "/tasks/:id" => "tasks#mark", as: :mark
    get :search, on: :collection
    post :flag, on: :member
    post :mark_done
  end
end
