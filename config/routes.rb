SocTest::Application.routes.draw do

  resources :questionaries

  root :to => 'pages#home'
end
