class AttendanceStat < ApplicationRecord
  included RailsAttend::AttendanceStat
end unless defined? AttendanceStat
