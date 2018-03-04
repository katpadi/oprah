class AddWonAtOnEntries < ActiveRecord::Migration[5.1]
  def change
    add_column :entries, :won_at, :datetime
  end
end
