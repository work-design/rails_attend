class AttendanceLog < ApplicationRecord
  include RailsAttend::AttendanceLog
end unless defined? AttendanceLog
