module Attend
  module Model::Absence::BusinessTrip
    extend ActiveSupport::Concern

    included do
      validates :note, presence: true
    end

  end
end
