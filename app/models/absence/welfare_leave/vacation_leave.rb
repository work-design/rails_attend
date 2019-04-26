class VacationLeave < WelfareLeave
  include RailsAttend::Absence::WelfareLeave::VacationLeave
end unless defined? VacationLeave
