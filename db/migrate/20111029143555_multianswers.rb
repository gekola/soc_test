class Multianswers < ActiveRecord::Migration
  def change
    add_column :questions, :extra_answer, :bool
    add_column :questions, :multians, :integer    
  end
end
