class CreateDeals < ActiveRecord::Migration
  def change
    create_table :deals do |t|
      t.string :name
      t.integer :event_id
      t.text :description
      t.decimal :how_much
      t.string :currency
      t.string :deal_type
      t.integer :category_id

      t.timestamps
    end
  end
end
