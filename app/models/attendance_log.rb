class AttendanceLog < ApplicationRecord
  include RailsAttend::AttendanceLog
  include RailsNotice::Notifiable
  include RailsAudit::CheckMachine
end unless defined? AttendanceLog
