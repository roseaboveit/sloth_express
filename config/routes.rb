SlothExpress::Application.routes.draw do

  root 'products#index'

  get "/products/admin_view" => "products#admin_view"
  get "/orders/empty" => "orders#empty"
  get "log_out"       => "sessions#destroy", :as => "log_out"
  get "log_in"        => "sessions#new",     :as => "log_in"
  get "sign_up"       => "users#new",        :as => "sign_up"
  get "vendors"       => "users#vendors",    :as => "vendors"
  get "sloth_king"    => "users#sloth_king"
  get "users/:id/order/:order_id" => "users#order", :as => "users_order"


  resources :products do
    collection do
      get 'search'
    end
    resources :reviews
  end

  resources :orders
  resources :categories
  resources :order_items
  resources :users
  resources :sessions
  resources :purchases
  resources :categories


  delete '/order_items/:id/remove_item/:product_id' => "order_items#remove_item", as: :remove_item
  post '/products/:id/retire_product/:product_id' => "products#retire_product", as: :retire_product
  post '/products/:id/activate_product/:product_id' => "products#activate_product", as: :activate_product
  post '/users/:id/completed/' => "orders#completed", as: :completed
  post '/users/:id/cancelled/' => "orders#cancelled", as: :cancelled

end
