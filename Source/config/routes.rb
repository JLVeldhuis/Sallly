Forevenue::Application.routes.draw do
  devise_for :users
  
  devise_scope :user do
    get "sign_in", :to => "devise/sessions#new"
  end
  
  resources :events
  resources :setting

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
