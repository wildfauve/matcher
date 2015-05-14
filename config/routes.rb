Rails.application.routes.draw do
  
  root 'people#index'
  
  resources :people do
    collection do
      get 'search_form'
      post 'search'
    end
    resources :matches do
      member do 
        post 'duplicate'
        post 'no_duplicate'
        post 'undecided'
      end                
    end
  end
  
  resources :admin do
    collection do
      post 'match'
    end
  end
  
end
