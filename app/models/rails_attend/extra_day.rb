module RailsAttend::ExtraDay
  extend ActiveSupport::Concern
  included do
    enum kind: {
      holiday: 'holiday',
      workday: 'workday'
    }
  end
  

end
