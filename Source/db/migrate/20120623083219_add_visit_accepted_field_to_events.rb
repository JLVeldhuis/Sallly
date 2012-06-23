class AddVisitAcceptedFieldToEvents < ActiveRecord::Migration
  def change
    add_column :events, :visit_accepted, :boolean
  end
end
