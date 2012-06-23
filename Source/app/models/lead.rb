class Lead < ActiveRecord::Base
  
  attr_accessor :description
  
  belongs_to :user
  has_many :events 
  
  attr_accessible :name, :crm_id, :crm_name, :crm_notes, :address, :city, :email, :phone
end
