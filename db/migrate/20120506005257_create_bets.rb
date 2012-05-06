class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string :thebet
      t.integer :user_id
      t.boolean :betresult

      t.timestamps
    end
    add_index :bets, [:user_id]
  end
end
