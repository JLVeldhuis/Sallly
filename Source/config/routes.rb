Forevenue::Application.routes.draw do
  get "sessions/new"

  resources :users
  resources :events
  resources :setting
  resources :sessions,  :only => [:new, :create, :destroy]

  match '/signup',      :to => 'users#new'
  match '/signin',      :to => 'sessions#new'
  match 'signout',      :to => 'sessions#destroy'

  match '/contact',     :to => 'pages#contact'
  match '/about',       :to => 'pages#about'
  match '/welcome',     :to => 'pages#welcome'
  match '/activities',  :to => 'pages#activities'
  match '/average',     :to => 'pages#average'
  match '/goal',        :to => 'pages#goal'
  match '/settings',    :to => 'pages#settings'
  match '/status',      :to => 'pages#status'
  match '/video',       :to => 'pages#video'

  match '/events/new',      :to => 'events#new'  
  match '/events/:id/edit', :to => 'events#edit'
  match '/get_events.json', :to => 'pages#get_events'

  root  :to => 'pages#home'
end
