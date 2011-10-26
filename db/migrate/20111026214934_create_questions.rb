class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :num
      t.text :content
      t.integer :questionary_id
    end
    add_index :questions, :num
    add_index :questions, :questionary_id
  end
end
