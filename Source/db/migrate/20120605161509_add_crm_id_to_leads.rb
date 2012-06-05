class AddCrmIdToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :crm_id, :string
  end
end
