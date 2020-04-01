class Attendance < ApplicationRecord
  include RailsAttend::Attendance
end unless defined? Attendance
