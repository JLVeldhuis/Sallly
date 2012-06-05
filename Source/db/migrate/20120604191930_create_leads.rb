class CreateLeads < ActiveRecord::Migration
  def change
    create_table  :leads do |t|
      t.string    :name
      t.string    :address
      t.string    :city
      t.string    :email
      t.string    :phone
      t.integer   :user_id

      t.timestamps
    end
  end
end
