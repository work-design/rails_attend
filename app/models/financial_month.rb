class FinancialMonth < ApplicationRecord
  included RailsAttend::FinancialMonth
end unless defined? FinancialMonth
