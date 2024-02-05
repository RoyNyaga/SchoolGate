Rails.application.routes.draw do
  resources :fees do
    collection do
      get :statistics
      post :search
    end
  end
  resources :report_cards do
    collection do
      post :bulk_create
      get :pdf_download
      get :auto_generate
      get :manually_create
    end
  end
  resources :terms
  resources :sequences
  resources :workings
  resources :teachings
  resources :subjects do
    member do
      get :for_teacher
    end
  end
  resources :students do
    member do
      put :update_photo
    end
  end
  resources :school_classes
  devise_for :teachers
  resources :teachers do
    collection do
      get :invitations
      get :subjects
    end

    member do
      put :update_photo
    end
  end
  get "pages/home"
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  resources :schools do
    collection do
      get :classes
      get :students
      get :teachers
      get :invitations
      get :contracts
      get :permissions
    end
  end

  resources :invitations do
    member do
      put :accept
      put :reject
    end
  end

  resources :charts, except: [:index, :show, :update, :edit, :new, :destroy, :create] do
    collection do
      get :complete_incomplete_pie
      get :incomplete_fee_per_installment_bar
      get :complete_fee_per_installment_bar
      get :incomplete_fee_per_class
      get :complete_fee_per_class
      get :revenue_per_class_over_time_line_chart
    end
  end
end
