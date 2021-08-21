Rails.application.routes.draw do
  resources :players do
    get :turbo
    
  end
  resources :games, path: '' do
    collection do
      get :all_games
    end
    get :playing
  end
  resources :words
  root to: 'games#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
