class AddFirstLoginToUser < ActiveRecord::Migration
  def change
    add_column :users, :first_login, :boolean, :default => 1
  end
end
