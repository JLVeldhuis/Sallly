Forevenue::Application.routes.draw do
  get "sessions/new"

  resources :users
  resources :sessions, :only => [:new, :create, :destroy]
  resources :setting

  match '/signup', :to => 'users#new'
  match '/signin', :to => 'sessions#new'
  match 'signout', :to => 'sessions#destroy'

  match '/contact', :to => 'pages#contact'
  match '/about', :to => 'pages#about'
  match '/welcome', :to => 'pages#welcome'
  match '/activities', :to => 'pages#activities'
  match '/average', :to => 'pages#average'
  match '/goal', :to => 'pages#goal'
    match '/settings', :to => 'pages#settings'
    match '/status', :to => 'pages#status'
    match '/video', :to => 'pages#video'

  root :to => 'pages#home'
end
