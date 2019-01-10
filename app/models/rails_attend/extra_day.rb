class ExtraDay < ApplicationRecord


  enum kind: {
    holiday: 'holiday',
    workday: 'workday'
  }

end
