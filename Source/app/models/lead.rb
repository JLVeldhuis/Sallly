class Lead < ActiveRecord::Base
  belongs_to :user
  has_many :events 
  
  attr_accessible :name, :crm_id, :crm_name, :crm_notes, :address, :city, :email, :phone
end
