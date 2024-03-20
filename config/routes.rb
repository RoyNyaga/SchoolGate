Rails.application.routes.draw do
  mount MissionControl::Jobs::Engine, at: "/jobs"
  resources :report_card_generators do
    member do
      get :loading
      get :progress_state_api
    end
  end
  resources :academic_years do
    member do
      put :toggle_activeness
    end
  end
  resources :progresses do
    member do
      get :more_details
    end
  end
  resources :topics
  resources :main_topics
  resources :curriculums
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
  resources :sequences do
    member do
      put :toggle_approval
    end
  end
  resources :workings
  resources :teachings
  resources :subjects do
    member do
      get :for_teacher
    end
  end
  resources :students do
    collection do
      get :json_search
    end

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
      get :progresses
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
      get :progresses
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
      get :report_card_performance_line
    end
  end
end
