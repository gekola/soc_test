SocTest::Application.routes.draw do

  get "pages/form"

  resources :questionaries
  resources :questions
  resources :answers, :only => [:new, :create, :destroy, :edit, :update, :verify]
  resources :results, :only => [:index]
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home'

  match '/form', :to => 'results#new', :via => :get
  match '/form', :to => 'results#create', :via => :post
  match '/thanks', :to => 'pages#thanks'
  match '/authors', :to => 'pages#authors'

  match '/answers/verify', :to => 'answers#verify'
  match '/answers/join', :to => 'answers#join'

  match 'stat', :to => 'results#statistics'
  match 'graph', :to => 'results#statistics.js'

  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
