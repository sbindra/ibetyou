class AddBetsharedToBets < ActiveRecord::Migration
  def change
    add_column :bets, :betshared, :boolean, default: false
  end
end
