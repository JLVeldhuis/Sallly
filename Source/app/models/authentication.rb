class Authentication < ActiveRecord::Base
  belongs_to :user
  
  validates :uid,
            :presence => true,
            :uniqueness => {:scope => [:provider, :user_id]}
end
