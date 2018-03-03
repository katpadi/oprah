class CreateWinners < ActiveRecord::Migration[5.1]
  def change
    create_table :winners do |t|
      t.integer :user_id
      t.integer :prize_id
      t.integer :entry_id

      t.timestamps
    end
  end
end
