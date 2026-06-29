Rails.application.routes.draw do
  root 'images#new'

  get 'legacy' => 'images#new', as: :legacy, defaults: {mode: :legacy}
  post 'upload' => 'images#create', as: :upload
  get 'donate' => 'images#donate', as: :donate
  get ':id/status' => 'images#status', as: :image_status
  get ':id/download' => 'images#download', as: :download
  get ':id' => 'images#show', as: :result

  namespace :admin do
    resources :images
  end
end
