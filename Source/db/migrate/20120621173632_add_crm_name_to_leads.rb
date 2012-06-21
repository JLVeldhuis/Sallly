class AddCrmNameToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :crm_name, :string
  end
end
