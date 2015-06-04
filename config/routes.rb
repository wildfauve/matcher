Rails.application.routes.draw do
  
  root 'people#index'
  
  resources :people do
    collection do
      get 'search_form'
      post 'search'
      get 'filtered'
    end
    resources :matches do
      member do 
        post 'duplicate'
        post 'no_duplicate'
        post 'undecided'
        post 'reducers'
      end                
    end
  end
  
  namespace :admin do
    resources :tasks, only: [:index]
    resources :settings
    resources :jobs do
      collection do
        post 'match'
        post 'export'
      end
    end
  end
  
end
