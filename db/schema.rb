# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140627083321) do

  create_table "data_sources", force: true do |t|
    t.string   "name"
    t.string   "connector_type"
    t.string   "primary",           default: "no"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "config_section_id"
  end

  add_index "data_sources", ["primary"], name: "index_data_sources_on_primary"

  create_table "data_sources_users", force: true do |t|
    t.integer "user_id",          null: false
    t.integer "data_source_id",   null: false
    t.integer "external_user_id"
  end

  create_table "fees", force: true do |t|
    t.integer  "report_id"
    t.string   "work_type",            default: "hourly"
    t.string   "comment"
    t.float    "hours"
    t.float    "sum"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "payroll_id"
    t.integer  "user_id"
    t.string   "currency",   limit: 3
  end

  add_index "fees", ["work_type"], name: "index_fees_on_work_type"

  create_table "invoice_report_users", force: true do |t|
    t.integer  "invoice_id"
    t.integer  "report_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "invoices_pack_id"
    t.integer  "user_id"
    t.integer  "report_id"
    t.string   "description"
    t.float    "amount_without_taxes"
    t.float    "tax_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_file_name",   limit: 1000
  end

  create_table "invoices_packs", force: true do |t|
    t.integer  "reports_pack_id"
    t.float    "with_taxes"
    t.float    "taxes"
    t.string   "base_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices_packs_user_reports", force: true do |t|
    t.integer "invoices_pack_id"
    t.integer "user_report_id"
  end

  create_table "payrolls", force: true do |t|
    t.integer  "user_id"
    t.float    "amount"
    t.string   "name"
    t.date     "effective_since"
    t.string   "work_type",       default: "hourly"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency",        default: "RUB"
  end

  add_index "payrolls", ["currency"], name: "index_payrolls_on_currency"
  add_index "payrolls", ["work_type"], name: "index_payrolls_on_work_type"

  create_table "reports", force: true do |t|
    t.date     "start_time"
    t.date     "finish_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "time_entries", force: true do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.string   "project"
    t.float    "hours"
    t.string   "comment"
    t.datetime "spent_on"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.integer  "external_id"
    t.string   "task"
    t.integer  "data_source_id"
  end

  create_table "user_details", force: true do |t|
    t.integer "user_id"
    t.integer "user_report_id"
    t.integer "fee_id"
    t.integer "time_entry_id"
    t.string  "project"
    t.float   "hours"
    t.string  "comment"
    t.date    "spent_on"
    t.string  "task"
  end

  create_table "user_reports", force: true do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.string   "name"
    t.string   "summary"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",     default: "pending"
  end

  add_index "user_reports", ["status"], name: "index_user_reports_on_status"

  create_table "users", force: true do |t|
    t.string   "login"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "mail"
    t.string   "skype"
    t.string   "gtalk"
    t.string   "phone"
    t.string   "os"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "external_user_id"
    t.string   "duty"
    t.date     "date_of_contract"
    t.float    "tax_percent"
    t.string   "address"
    t.string   "city"
    t.string   "country"
    t.string   "zip"
    t.string   "name_for_bank_account"
    t.string   "bank_account_number"
    t.string   "bank_swift"
    t.string   "bank_name"
    t.boolean  "hidden",                default: false
    t.boolean  "active",                default: true
  end

end
