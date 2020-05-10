module RailsAttend::AbsenceStat
  extend ActiveSupport::Concern

  included do
    attribute :year, :string
    attribute :annual_days, :float
    attribute :annual_add, :float
    attribute :left_annual_days, :float
    attribute :vacation_days, :float
    attribute :details, :string, limit: 1024

    belongs_to :member
  end

end
