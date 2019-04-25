module RailsAttend::Absence::BusinessTrip
  extend ActiveSupport::Concern
  included do
    validates :note, presence: true
  end
  
end
