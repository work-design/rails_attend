class AttendanceSetting < ApplicationRecord
  included RailsAttend::AttendanceSetting
  include RailsAudit::CheckMachine
end unless defined? AttendanceSetting
