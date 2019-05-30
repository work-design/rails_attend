module RailsAttend::Overtime
  extend ActiveSupport::Concern
  included do
    attribute :state, :string, default: 'init'
    include CheckMachine
    belongs_to :member
    validates :start_at, presence: true
    validates :finish_at, presence: true
  
    enum state: {
      init: 'init',
      approved: 'approved',
      denied: 'denied',
      confirmed: 'confirmed'
    }
  
    before_save :compute_hours
    after_create_commit :send_notification
  
    validate :validate_same_date
  
    delegate :name, to: :member, prefix: true
  
    acts_as_notify :default,
                   only: [:hours, :start_at, :finish_at, :note],
                   methods: [:state_i18n]
    acts_as_notify :request,
                   only: [:hours, :start_at, :finish_at, :note],
                   methods: [:member_name]
  end
  
  def do_trigger(params = {})
    self.trigger_to state: params[:state]

    self.class.transaction do
      self.save!
      to_notification(
        receiver: self.member,
        link: url_helpers.oa_overtimes_url(id: self.id),
        verbose: true
      )
    end
  end

  def send_notification
    to_notification(
      receiver: self.member.parent,
      cc_emails: [
        self.member.office&.absence_email,
        self.member.email,
        *cc_emails
      ],
      link: url_helpers.my_admin_overtimes_url(id: self.id),
      code: :request,
      verbose: true
    )
  end

  def compute_hours
    _hours = (self.finish_at - self.start_at).div(1800) / 2.0

    if _hours > 0 && _hours <= 4
      self.hours = _hours
    elsif _hours > 4 && _hours <= 5
      self.hours = 4
    elsif _hours > 5 && _hours <= 9
      self.hours = _hours - 1
    elsif _hours > 9
      self.hours = 8
    end
  end

  def validate_same_date
    if self.finish_at.to_date != self.start_at.to_date
      self.errors.add :base, 'Start At and Finish At must be in same day!'
    end
    if self.finish_at < self.start_at
      self.errors.add :base, 'Start At can not later than Finish At!'
    end
  end

end
