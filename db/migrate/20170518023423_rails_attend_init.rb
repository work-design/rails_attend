class RailsAttendInit < ActiveRecord::Migration[5.1]
  def change

    create_table :attendances do |t|
      t.references :member
      t.integer :late_minutes
      t.integer :leave_minutes
      t.float :overtime_hours
      t.datetime :start_at
      t.datetime :finish_at
      t.date :attend_on
      t.datetime :interval_start_at
      t.datetime :interval_finish_at
      t.float :attend_hours
      t.string :kind
      t.float :interval_hours
      t.integer :interval_absence_id
      t.integer :late_absence_id
      t.integer :leave_absence_id
      t.float :total_hours
      t.integer :absence_minutes
      t.boolean :absence_redeeming
      t.string :lost_logs
      t.boolean :workday, default: true
      t.boolean :processed, default: false
      t.timestamps
    end

    create_table :attendance_logs do |t|
      t.references :member
      t.references :attendance
      t.string :name
      t.string :number
      t.datetime :record_at
      t.boolean :processed, default: false
      t.string :state
      t.string :kind
      t.string :source
      t.string :note
      t.string :record_at_str
      t.timestamps
    end

    create_table :attendance_settings do |t|
      t.references :member
      t.references :financial_month
      t.string :on_time
      t.string :off_time
      t.string :state
      t.string :note
      t.timestamps
    end

    create_table :attendance_stats do |t|
      t.references :member
      t.references :financial_month
      t.integer :allowance_days
      t.integer :late_days
      t.float :absence_redeeming_hours
      t.string :costed_absence, limit: 1024
      t.float :cost_absence_hours
      t.string :free_absence, limit: 1024
      t.string :redeeming_absence, limit: 1024
      t.float :holiday_redeeming_hours
      t.boolean :processed, default: false
      t.timestamps
    end

    create_table :absences do |t|
      t.references :member
      t.string :kind
      t.string :type
      t.float :hours
      t.datetime :start_at
      t.datetime :finish_at
      t.string :state
      t.string :note, limit: 2048
      t.string :comment, limit: 2048
      t.boolean :redeeming
      t.string :redeeming_days
      t.boolean :processed, default: false
      t.integer :merged_id
      t.boolean :divided, default: false
      t.timestamps
    end

    create_table :absence_stats do |t|
      t.references :member
      t.string :year
      t.float :annual_days
      t.float :annual_add
      t.float :left_annual_days
      t.float :vacation_days
      t.string :details, limit: 1024
      t.timestamps
    end

    create_table :overtimes do |t|
      t.references :member
      t.datetime :start_at
      t.datetime :finish_at
      t.string :state
      t.string :note, limit: 1024
      t.string :comment, limit: 1024
      t.float :hours
      t.timestamps
    end

    create_table :extra_days do |t|
      t.references :organ
      t.date :the_day
      t.string :name
      t.string :kind, comment: 'holiday, workday'
      t.string :scope
      t.timestamps
    end

    create_table :financial_months do |t|
      t.references :organ
      t.date :begin_date
      t.date :end_date
      t.string :working_days
      t.string :color
      t.timestamps
    end

  end
end

