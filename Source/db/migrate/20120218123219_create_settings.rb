class CreateSettings < ActiveRecord::Migration
  def self.up
    create_table :settings do |t|
        t.column :goal_revenue, :integer
        t.column :goal_start, :date
        t.column :goal_end, :date
        t.column :average_revenue, :integer
        t.column :average_start, :date
        t.column :average_end, :date
        t.column :activity_level, :integer
        t.column :activity_calls, :integer
        t.column :activity_visits, :integer
        t.column :activity_quotes, :integer
        t.column :average_workdays_a_year, :integer
        t.column :average_workdays_a_week, :integer
        t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
      drop_table :settings
  end
end
