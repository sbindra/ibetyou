class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.boolean :pick
      t.integer :user_id
      t.integer :bet_id

      t.timestamps
    end
    add_index :picks, :user_id
    add_index :picks, :bet_id
  end
end
