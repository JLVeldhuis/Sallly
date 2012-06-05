class AddLeadToEvents < ActiveRecord::Migration
  def change
    add_column :events, :lead_id, :integer
  end
end
