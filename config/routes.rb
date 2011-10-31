SocTest::Application.routes.draw do

  resources :questionaries, :questions

  root :to => 'pages#home'
end
