class Absence < ApplicationRecord
  included RailsAttend::Absence
end unless defined? Absence
