class ChangeEventtypeToInteger < ActiveRecord::Migration
  def up
    change_column :events, :eventtype, :integer, :default => 4
  end

  def down
    change_column :events, :eventtype, :string
  end
end
