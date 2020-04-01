class Absence < ApplicationRecord
  include RailsAttend::Absence
  include RailsAudit::CheckMachine
end unless defined? Absence
