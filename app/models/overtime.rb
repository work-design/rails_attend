class Overtime < ApplicationRecord
  included RailsAttend::Overtime
  include RailsAudit::CheckMachine
end unless defined? Overtime
