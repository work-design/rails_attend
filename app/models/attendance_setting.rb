class AttendanceSetting < ApplicationRecord
  include RailsAttend::AttendanceSetting
  include RailsAudit::CheckMachine
end unless defined? AttendanceSetting
