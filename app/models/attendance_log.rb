class AttendanceLog < ApplicationRecord
  included RailsAttend::AttendanceLog
  include RailsNotice::Notifiable
  include RailsAudit::CheckMachine
end unless defined? AttendanceLog
