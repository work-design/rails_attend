module Attend
  module RailsAttend::ExtraDay
    extend ActiveSupport::Concern

    included do
      attribute :the_day, :date
      attribute :name, :string
      attribute :kind, :string, comment: 'holiday, workday'
      attribute :scope, :string

      belongs_to :organ, optional: true

      enum kind: {
        holiday: 'holiday',
        workday: 'workday'
      }
    end


  end
end
