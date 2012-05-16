class AddFlagsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :source,    :boolean, :default => false
    add_column :events, :is_active, :boolean, :default => false
  end
end
