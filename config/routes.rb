Rails.application.routes.draw do
  # resources :serimayas, only: [:index] => 'serimaya'
  get 'serimaya', to: 'serimayas#index'
  get 'prima16', to: 'prima16s#index'
end
