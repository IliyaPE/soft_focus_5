Rails.application.routes.draw do
  root 'images#new'

  get 'legacy' => 'images#new', as: :legacy, defaults: {mode: :legacy}
  post 'upload' => 'images#create', as: :upload
  get ':id' => 'images#show', as: :result
  get ':id/download' => 'images#download', as: :download

  namespace :admin do
    resources :images
  end
end
