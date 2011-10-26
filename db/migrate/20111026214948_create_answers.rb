class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :num
      t.text :content
      t.integer :question_id
    end
    add_index :answers, :num
    add_index :answers, :question_id
  end
end
