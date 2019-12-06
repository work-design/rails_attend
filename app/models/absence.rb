class Absence < ApplicationRecord
  included RailsAttend::Absence
  include RailsAudit::CheckMachine
end unless defined? Absence
