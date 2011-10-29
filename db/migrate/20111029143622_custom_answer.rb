class CustomAnswer < ActiveRecord::Migration
  def change
    add_column :answers, :verified, :boolean
    add_column :answers, :result_id, :integer

    add_index :answers, :verified
  end
end
