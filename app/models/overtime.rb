class Overtime < ApplicationRecord
  include RailsAttend::Overtime
  include RailsAudit::CheckMachine
end unless defined? Overtime
