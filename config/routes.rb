Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/' ,to: "welcome#index"

  resources :merchants, only: [:show] do
    resources :items, except: [:destroy]
    resources :invoices, only: [:index, :show] 
    resources :dashboard, only: [:index]
    
  end

  resources :admin, controller: 'admin/dashboard', only: [:index]
  namespace :admin do

    resources :invoices, only: [:index, :show, :update]
    resources :merchants, except: [:destroy]
  end

  # patch 'admin/merchants/:id', to: 'admin/merchants#update'
  patch '/merchants/:merchant_id/invoice_items', to: 'invoice_items#update'
  
  post '/merchants/:merchant_id/bulk_discounts', to: 'bulk_discounts#create'
  get '/merchants/:merchant_id/bulk_discounts', to: 'bulk_discounts#index'
  get '/merchants/:merchant_id/bulk_discounts/new', to: 'bulk_discounts#new'
  get '/merchants/:merchant_id/bulk_discounts/:id', to: 'bulk_discounts#show'
  delete '/merchants/:merchant_id/bulk_discounts/:id', to: 'bulk_discounts#destroy'
  patch '/merchants/:merchant_id/bulk_discounts/:id/edit', to: 'bulk_discounts#edit'
  get '/merchants/:merchant_id/bulk_discounts/:id/edit', to: 'bulk_discounts#edit'
  patch '/merchants/:merchant_id/bulk_discounts/:id', to: 'bulk_discounts#update'
   
end
