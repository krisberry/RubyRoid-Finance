Rails.application.routes.draw do
  resources :events
  resources :invitations, only: [:new, :create]
  get 'payments', to: 'payments#index'
  get 'chat', to: 'home#index'

  devise_scope :user do
    get 'signout', to: 'users/sessions#destroy'
    get 'users/sign_up/:invited_code', to: 'users/registrations#new', as: :new_registration

    authenticated :user do
      root 'dashboard#index', as: :authenticated_root
      get 'calendar', to: 'dashboard#calendar'
      get 'users/autocomplete', to: 'users#autocomplete', as: 'autocomplete_users'
    end

    unauthenticated do
      root 'users/sessions#new', as: :unauthenticated_root
    end

    post 'tokens' => "tokens#create"
  end

  namespace :admin do
    root 'dashboard#index'
    resources :users do
      patch 'pay_for_event', on: :member
    end

    resources :invitations, except: [:update]
    patch 'invitations/:id', to: 'invitations#resend', as: 'invitation_resend'
    patch 'invitation/:id', to: 'invitations#approve_user', as: 'approve'

    resources :events

    resources :payments, only: [:index]
    resources :rates, only: [:edit, :update]
    resources :items, only: [:new, :create]
  end

  devise_for :users, controllers: { :omniauth_callbacks => "users/omniauth_callbacks", sessions: "users/sessions", registrations: "users/registrations", passwords: "users/passwords" }

  # The priority is based upon order of creation: first created -> highest iority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
