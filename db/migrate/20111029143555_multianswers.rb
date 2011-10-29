class Multianswers < ActiveRecord::Migration
  def change
    add_column :questions, :extra_answer, :boolean
    add_column :questions, :multians, :integer
  end
end
