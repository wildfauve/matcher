Rails.application.routes.draw do
  
  root 'people#index'
  
  resources :people do
    resource :matches
    collection do
      get 'search_form'
      post 'search'
    end
    
  end
  
end
