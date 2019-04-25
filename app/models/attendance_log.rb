class AttendanceLog < ApplicationRecord
  included RailsAttend::AttendanceLog
end unless defined? AttendanceLog
