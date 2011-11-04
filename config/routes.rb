SocTest::Application.routes.draw do

  resources :questionaries
  resources :questions
  resources :sessions, :only => [:new, :create, :destroy]

  root :to => 'pages#home'

  match '/signin',  :to => 'sessions#new'
  match '/signout', :to => 'sessions#destroy'
end
