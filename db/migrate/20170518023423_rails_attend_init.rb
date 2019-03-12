class RailsAuthInit < ActiveRecord::Migration[5.1]
  def change

    create_table "absence_stats" do |t|
      t.bigint "member_id"
      t.string "year"
      t.float "annual_days"
      t.float "annual_add"
      t.float "left_annual_days"
      t.float "vacation_days"
      t.string "details", limit: 1024
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["member_id"], name: "index_absence_stats_on_member_id"
    end

    create_table "absences" do |t|
      t.string "kind"
      t.string "type"
      t.bigint "member_id"
      t.float "hours"
      t.datetime "start_at"
      t.datetime "finish_at"
      t.string "state"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "note", limit: 2048
      t.string "comment", limit: 2048
      t.boolean "redeeming"
      t.string "cc_emails"
      t.string "redeeming_days"
      t.boolean "processed", default: false
      t.integer "merged_id"
      t.boolean "divided", default: false
      t.index ["member_id"], name: "index_absences_on_member_id"
    end

    create_table "attendance_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.string "name"
      t.string "number"
      t.datetime "record_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "processed", default: false
      t.string "state"
      t.bigint "attendance_id"
      t.string "kind"
      t.bigint "member_id"
      t.string "source"
      t.string "note"
      t.string "record_at_str"
      t.index ["attendance_id"], name: "index_attendance_logs_on_attendance_id"
      t.index ["member_id"], name: "index_attendance_logs_on_member_id"
    end

    create_table "attendance_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "member_id"
      t.bigint "financial_month_id"
      t.string "on_time"
      t.string "off_time"
      t.string "state"
      t.string "note"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["financial_month_id"], name: "index_attendance_settings_on_financial_month_id"
      t.index ["member_id"], name: "index_attendance_settings_on_member_id"
    end

    create_table "attendance_stats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
      t.bigint "member_id"
      t.bigint "financial_month_id"
      t.integer "allowance_days"
      t.integer "late_days"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.float "absence_redeeming_hours"
      t.string "costed_absence", limit: 1024
      t.float "cost_absence_hours"
      t.string "free_absence", limit: 1024
      t.string "redeeming_absence", limit: 1024
      t.float "holiday_redeeming_hours"
      t.boolean "processed", default: false
      t.index ["financial_month_id"], name: "index_attendance_stats_on_financial_month_id"
      t.index ["member_id"], name: "index_attendance_stats_on_member_id"
    end

    create_table "attendances", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "member_id"
      t.integer "late_minutes"
      t.integer "leave_minutes"
      t.float "overtime_hours"
      t.datetime "start_at"
      t.datetime "finish_at"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.date "attend_on"
      t.datetime "interval_start_at"
      t.datetime "interval_finish_at"
      t.float "attend_hours"
      t.string "kind"
      t.float "interval_hours"
      t.integer "interval_absence_id"
      t.integer "late_absence_id"
      t.integer "leave_absence_id"
      t.float "total_hours"
      t.integer "absence_minutes"
      t.boolean "absence_redeeming"
      t.string "lost_logs"
      t.boolean "workday", default: true
      t.boolean "processed", default: false
      t.index ["member_id"], name: "index_attendances_on_member_id"
    end

    create_table "overtimes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
      t.bigint "member_id"
      t.datetime "start_at"
      t.datetime "finish_at"
      t.string "state"
      t.string "note", limit: 1024
      t.string "comment", limit: 1024
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.float "hours"
      t.string "cc_emails"
      t.index ["member_id"], name: "index_overtimes_on_member_id"
    end



  end
end

