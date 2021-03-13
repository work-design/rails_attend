Rails.application.routes.draw do

  scope :admin, module: 'attend/admin', as: :admin, defaults: { business: 'attend', namespace: 'admin' } do
    resources :financial_months do
      member do
        get :events
        patch :attendance_setting
      end
    end
    resources :absence_stats
    resources :extra_days
    resources :absences do
      collection do
        get :my
      end
      member do
        patch :trigger
      end
    end
    resources :overtimes, except: [:new, :create] do
      collection do
        get :my
      end
      member do
        patch :trigger
      end
    end
    resources :attendances do
      collection do
        get :my
      end
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
