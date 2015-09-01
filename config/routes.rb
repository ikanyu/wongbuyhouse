Rails.application.routes.draw do
  # resources :serimayas, only: [:index] => 'serimaya'
  root 'serimayas#index'
  get 'serimaya', to: 'serimayas#index'
  get 'prima16', to: 'prima16s#index'
  get 'gresidence', to: 'gresidences#index'
  get 'gembiraresidence', to: 'gembiraresidences#index'
  get 'twoeighteightresidence', to: 'twoeighteightresidences#index'
end
