Perceptivemedia::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  
  # HelloWorld class Route
  #get "hello_controller/hello" => "hello_controller#hello"
  #get "input/input" => "input#input"
  #get "input/updateconfig" => "input#updateconfig"


  #match "hello_controller/hello" => "hello_controller#hello", :via => :post
  #match "input/create" => "input#create", :via => :post
  #match "input/create" => "input#create", :via => :get
  #match "input/input" => "input#input", :via => :post
  #match "input/input" => "input#input", :via => :get

  get "csv/form" => "csv#form"
  post "csv/form" => "csv#form"
  
  get "csv/create" => "csv#create"
  post "csv/create" => "csv#create"

  get "csv/createcsv_all" => "csv#createcsv_all"
  post "csv/createcsv_all" => "csv#createcsv_all"

  get "csv/createcsv_dynamic" => "csv#createcsv_dynamic"
  post "csv/createcsv_dynamic" => "csv#createcsv_dynamic"


  #match "input/input" => "input#input", :as => :input
end
