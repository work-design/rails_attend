class AttendanceLog < ApplicationRecord
  include RailsAttend::AttendanceLog
  include RailsNotice::Notifiable
end unless defined? AttendanceLog
