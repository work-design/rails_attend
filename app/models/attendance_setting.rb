class AttendanceSetting < ApplicationRecord
  included RailsAttend::AttendanceSetting
end unless defined? AttendanceSetting
