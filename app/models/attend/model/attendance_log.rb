module Attend
  module RailsAttend::AttendanceLog
    extend ActiveSupport::Concern

    included do
      attribute :source, :string, default: 'machine'
      attribute :state, :string, default: 'init'
      attribute :name, :string
      attribute :record_at, :datetime
      attribute :processed, :boolean, default: false
      attribute :kind, :string
      attribute :note, :string
      attribute :record_at_str, :string
      attribute :number, :string

      belongs_to :unsure_member, class_name: 'Member', foreign_key: 'number', primary_key: 'attendance_number', optional: true
      belongs_to :member, optional: true
      belongs_to :attendance, optional: true

      validates :record_at, presence: true, unless: -> { self.source == 'machine' }
      validates :record_at_str, presence: true, if: -> { self.source == 'machine' }

      scope :pending, -> { where(state: 'init', processed: false) }

      enum state: {
        init: 'init',
        valid: 'valid',
        invalid: 'invalid'
      }, _prefix: true

      enum kind: {
        start_at: 'start_at',
        finish_at: 'finish_at',
        interval_start_at: 'interval_start_at',
        interval_finish_at: 'interval_finish_at'
      }

      enum source: {
        machine: 'machine',
        myself: 'myself',
        admin: 'admin'
      }

      delegate :name, to: :member, prefix: true
      acts_as_notify :default,
                     only: [:record_at, :note],
                     methods: [:member_name, :state_i18n]
      acts_as_notify :request,
                     only: [:record_at, :note],
                     methods: [:member_name]

      after_initialize if: :new_record? do
        self.state ||= 'init'
      end
      before_save :sync_member_id, if: -> { number_changed? }
    end

    def sync_member_id
      self.member_id = self.unsure_member&.id
      if self.member
        self.record_at = self.record_at_str.in_time_zone(member.timezone)
      end
    end

    def do_trigger(params = {})
      self.trigger_to(params.slice(:state))

      self.class.transaction do
        self.save!
        to_notification(
          member: member,
          link: url_helpers.oa_attendance_logs_url(id: self.id),
          verbose: true,
        )
      end
    end

    def send_notification
      to_notification(
        member: member.parent,
        cc_emails: [
          self.member.office&.absence_email
        ],
        link: url_helpers.my_admin_attendance_logs_url(id: self.id),
        code: :request,
        verbose: true,
        )
    end

    def editable?
      self.state_init? && self.myself?
    end

    def record_at_begin
      record_at.at_beginning_of_day
    end

    def record_at_end
      record_at.at_end_of_day
    end

    def compute
      analyze
      self.attendance.compute_summary!
    end

    def analyze
      return unless self.member
      att = self.member.attendances.find_or_initialize_by('attend_on': self.record_at)
      _kind = att.compute_time_type self.record_at

      self.kind = _kind
      self.processed = true
      self.state = 'valid'

      self.attendance = att

      self.class.transaction do
        self.redress_same_logs
        att.save!
        self.save!
      end
    end

    def redress_same_logs
      return AttendanceLog.none unless self.attendance
      logs = AttendanceLog.where.not(id: self.id).where(member_id: self.member_id, attendance_id: self.attendance_id)
      times = [attendance.start_at, attendance.interval_start_at, attendance.interval_finish_at, attendance.finish_at]
      kinds = ['start_at', 'interval_start_at', 'interval_finish_at', 'finish_at']

      logs.each do |log|
        index = times.find_index { |x| x == log.record_at }
        if index
          _kind = kinds[index]
        else
          _kind = nil
        end
        log.kind = _kind
        log.save!
      end
    end

    class_methods do
      def analyze
        AttendanceLog.where(processed: false).each do |al|
          al.analyze
        end
      end

      def prepare
        Attendance.where(member_id: nil).each do |i|
          i.sync_member_id
          i.save
        end
      end

      def self.analyze_number
        Member.where(enabled: true, attendance_number: [nil, '']).each do |member|
          num = AttendanceLog.find_by(source: 'machine', name: member.profile&.real_name)&.number
          member.update(attendance_number: num)
        end
      end
    end
  end
end
