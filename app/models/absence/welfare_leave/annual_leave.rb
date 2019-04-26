class AnnualLeave < WelfareLeave
  include RailsAttend::Absence::WelfareLeave::AnnualLeave
end unless defined? AnnualLeave
