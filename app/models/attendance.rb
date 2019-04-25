class Attendance < ApplicationRecord
  included RailsAttend::Attendance
end unless defined? Attendance
