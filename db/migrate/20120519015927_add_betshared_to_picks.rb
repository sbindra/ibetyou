class AddBetsharedToPicks < ActiveRecord::Migration
  def change
    add_column :picks, :betshared, :boolean, default: false
  end
end
