class AddDealIdToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :dealId, :string
  end
end
