class Overtime < ApplicationRecord
  included RailsAttend::Overtime
end unless defined? Overtime
