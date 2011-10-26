class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.text :information
      t.integer :questionary_id
    end
    add_index :results, :questionary_id
  end
end
