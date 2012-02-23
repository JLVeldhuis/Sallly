class CreateCalendarEvents < ActiveRecord::Migration
    def self.up
        create_table :calendar_events do |t|
        t.column :title, :string
        t.column :date_from, :date
        t.column :date_to, :date
        t.column :location, :string
        t.column :eventtype, :string
        t.column :crm, :string
        t.column :tips, :string
        t.column :user_id, :integer
        t.timestamps
        end
    end

    def self.down
        drop_table :calendar_events
    end
end
