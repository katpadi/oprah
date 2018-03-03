class CreateEntries < ActiveRecord::Migration[5.1]
  def change
    create_table :entries do |t|
      t.text :comment
      t.integer :user_id
      t.integer :prize_id

      t.timestamps
    end
  end
end
