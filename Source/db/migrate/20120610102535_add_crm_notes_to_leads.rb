class AddCrmNotesToLeads < ActiveRecord::Migration
  def change
    add_column :leads, :crm_notes, :text
  end
end
