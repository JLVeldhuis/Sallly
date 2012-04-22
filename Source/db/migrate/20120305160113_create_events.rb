class CreateEvents < ActiveRecord::Migration
    def self.up
        create_table :events do |t|
            t.column :title, :string
            t.column :date_from, :datetime
            t.column :date_to, :datetime
            t.column :location, :string
            t.column :eventtype, :string
            t.column :crm, :string
            t.column :tips, :string
            t.column :user_id, :integer
            t.timestamps
        end
    end

    def self.down
        drop_table :events
    end
end
