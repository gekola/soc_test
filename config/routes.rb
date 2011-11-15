SocTest::Application.routes.draw do

  get "pages/form"

  resources :questionaries
  resources :questions
  resources :answers, :only => [:new, :create, :destroy, :edit, :update]
  resources :results, :only => [:index]
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home'

  match '/form', :to => 'results#new', :via => :get
  match '/form', :to => 'results#create', :via => :post
  match '/thanks', :to => 'pages#thanks'

  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
