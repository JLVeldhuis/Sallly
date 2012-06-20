class AddCrmChoiceForUser < ActiveRecord::Migration
  def change
    add_column :settings, :crm_option, :string, :default => "highrise"
  end
end
