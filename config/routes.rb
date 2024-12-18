Rails.application.routes.draw do
  resources :performance_sheets do
    member do
      put :regenerate
      get :download
    end
  end
  resources :deposits
  resources :competences
  resources :school_approval_requests
  resources :tutorials
  mount MissionControl::Jobs::Engine, at: "/jobs"

  # devise_for :admin_users, ActiveAdmin::Devise.config
  devise_for :admin_users, ActiveAdmin::Devise.config.merge(controllers: { sessions: "active_admin/sessions" })
  ActiveAdmin.routes(self)
  resources :receipts do
    collection do
      get :verification
    end

    member do
      get :parents
      get :pdf_view
      get :pdf_download
    end
  end
  resources :course_results
  resources :assessments do
    collection do
      post :redirect_to_new
    end
  end
  resources :enrollments do
    collection do
      get :search
    end
  end
  resources :course_registrations
  resources :semesters do
    member do
      put :toggle_activeness
    end
  end
  resources :lecturings
  resources :courses do
    collection do
      get :json_search
    end
    member do
      get :for_lecturer
    end
  end
  resources :departments
  resources :faculties
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
      get :pdf_download
    end

    member do
      get :receipts
    end
  end
  resources :report_cards do
    collection do
      post :bulk_create
      get :pdf_download
      get :auto_generate
      get :manually_create
      get :pdf_testing
    end
    member do
      get :pdf_view
    end
  end
  resources :terms
  resources :sequences do
    member do
      put :toggle_approval
    end
  end
  resources :workings
  resources :teachings do
    member do
      put :toggle_status
    end
  end
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
      get :id_card
      get :id_card_pdf_download
    end
  end
  resources :school_classes do
    member do
      get :list
      get :fees
      get :view_class_list_pdf
      get :performance_sheets
    end
  end
  devise_for :teachers
  resources :teachers do
    collection do
      get :invitations
      get :subjects
      get :courses
    end

    member do
      put :update_photo
      get :progresses
    end
  end
  get "contact-us", to: "pages#contact"
  get "privacy-policy", to: "pages#privacy_policy"
  get "service-terms", to: "pages#service_terms"
  get "pricing", to: "pages#pricing"
  post "create-message", to: "pages#create_message"
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
      get :faculties
      get :departments
      get :levels
      get :accounting_dashboard
    end
    member do
      put :update_logo
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

  resources :student_dashboards do
    collection do
      get :login
      post :create_session
      get :course_registrations
      get :results
    end

    member do
      delete :destroy_session_path
    end
  end

  resources :questionnaires do
    collection do
      get "teacher-questionnaire", to: "questionnaires#new_teacher_questionnaire"
      post :create_teacher
      get "proprietor-questionnaire", to: "questionnaires#new_proprietor_questionnaire"
      post :create_proprietor
      get :thanks
    end
  end
end
