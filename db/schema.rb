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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111029143622) do

  create_table "answers", :force => true do |t|
    t.integer "num"
    t.text    "content"
    t.integer "question_id"
    t.boolean "verified"
    t.integer "result_id"
  end

  add_index "answers", ["num"], :name => "index_answers_on_num"
  add_index "answers", ["question_id"], :name => "index_answers_on_question_id"
  add_index "answers", ["verified"], :name => "index_answers_on_verified"

  create_table "questionaries", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questionaries", ["created_at"], :name => "index_questionaries_on_created_at"

  create_table "questions", :force => true do |t|
    t.integer "num"
    t.text    "content"
    t.integer "questionary_id"
    t.boolean "extra_answer"
    t.integer "multians"
  end

  add_index "questions", ["num"], :name => "index_questions_on_num"
  add_index "questions", ["questionary_id"], :name => "index_questions_on_questionary_id"

  create_table "results", :force => true do |t|
    t.text    "information"
    t.integer "questionary_id"
  end

  add_index "results", ["questionary_id"], :name => "index_results_on_questionary_id"

end
