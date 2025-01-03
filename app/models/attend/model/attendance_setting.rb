module Attend
  module Model::AttendanceSetting
    extend ActiveSupport::Concern

    included do
      attribute :effect_on, :date
      attribute :expire_on, :date
      attribute :on_time, :string, default: '08:30'
      attribute :off_time, :string
      attribute :note, :string

      belongs_to :member

      enum :state, {
        init: 'init',
        approved: 'approved',
        denied: 'denied'
      }, default: 'init'

      after_initialize do
        self.compute_off_time
      end
      before_save :compute_off_time, if: -> { on_time_changed? }

      acts_as_notify
    end

    def do_trigger(params = {})
      self.trigger_to(params.slice(:state))

      self.class.transaction do
        self.save!
        member.save!
        to_notification(
          member: member,
          title: "Your Attendance Setting has been #{self.state_i18n}",
          body: "Your Attendance Setting has been #{self.state_i18n}",
          link: url_helpers.oa_attendance_settings_url
        )
      end
    end

    def compute_off_time
      if ['08', '8'].include? on_time.to_s.split(':').first
        self.off_time = '17:30'
      else
        self.off_time = '18:00'
      end
    end

    class_methods do
      def time_options
        [
          ['09:00', '09:00'],
          ['08:30', '08:30']
        ]
      end
    end

  end
end
