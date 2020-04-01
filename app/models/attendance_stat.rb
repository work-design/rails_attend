class AttendanceStat < ApplicationRecord
  include RailsAttend::AttendanceStat
end unless defined? AttendanceStat
