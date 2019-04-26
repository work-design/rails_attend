class PersonalLeave < Absence
  include RailsAttend::Absence::PersonalLeave
end unless defined? PersonalLeave
