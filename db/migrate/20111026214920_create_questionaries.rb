class CreateQuestionaries < ActiveRecord::Migration
  def change
    create_table :questionaries do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
    add_index :questionaries, :created_at
  end
end
