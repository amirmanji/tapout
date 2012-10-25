Tapout::Application.routes.draw do
  root to: 'matches#index'

  resources :sports
  resources :players
end
