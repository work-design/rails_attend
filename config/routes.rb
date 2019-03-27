Rails.application.routes.draw do

  scope :admin, module: 'attend/admin', as: 'admin' do
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
      get :my, on: :collection
      post :check, on: :collection
      patch :analyze, on: :member
    end
    resources :attendance_stats
    resources :attendance_settings do
      get :my, on: :collection
      post :check, on: :collection
    end
  end

  scope :my, module: 'attend/my', as: 'my' do
    resource :calendar do
      get :events
    end
    resources :attendance_stats
    resources :attendance_settings
    resources :attendances
    resources :attendance_logs

    resources :absences do
      get :dashboard, on: :collection
      get :redeeming, on: :collection
    end
    resources :overtimes
  end

end
