class AttendanceSetting < ApplicationRecord
  include RailsAttend::AttendanceSetting
end unless defined? AttendanceSetting
