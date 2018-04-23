Rails.application.routes.draw do
  resources :bugs
  resources :projects
  devise_for :users
  root 'application#home'
end