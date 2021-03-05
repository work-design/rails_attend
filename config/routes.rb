Rails.application.routes.draw do

  scope :admin, module: 'attend/admin', as: :admin, defaults: { business: 'attend', namespace: 'admin' } do
    resources :financial_months do
      get :events, on: :collection
      patch :attendance_setting, on: :member
    end
    resources :absence_stats
    resources :extra_days
    resources :absences do
      get :my, on: :collection
      patch :trigger, on: :member
    end
    resources :overtimes, except: [:new, :create] do
      get :my, on: :collection
      patch :trigger, on: :member
    end
    resources :attendances do
      get :my, on: :collection
    end
    resources :attendance_logs do
      collection do
        get :my
        post :check
      end
      member do
        patch :analyze
      end
    end
    resources :attendance_stats
    resources :attendance_settings do
      collection do
        get :my
        post :check
      end
    end
  end

  scope :me, module: 'attend/me', as: :me, defaults: { business: 'attend', namespace: 'me' } do
    resource :calendar do
      get :events
    end
    resources :attendance_stats
    resources :attendance_settings
    resources :attendances
    resources :attendance_logs
    resources :absences do
      collection do
        get :dashboard
        get :redeeming
      end
    end
    resources :overtimes
  end

end
