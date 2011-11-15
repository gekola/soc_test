SocTest::Application.routes.draw do

  get "pages/form"

  resources :questionaries
  resources :questions
  resources :answers, :only => [:new, :create, :destroy, :edit, :update]
  resources :results, :only => [:new, :create, :index]
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home'

  match '/form', :to => 'results#new'
  match '/thanks', :to => 'pages#thanks'

  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
