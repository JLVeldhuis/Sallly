class Deal < ActiveRecord::Base
  belongs_to :event
  belongs_to :category
  
  DEALTYPE = {
               "Fixed bid"    => "fixed",
               "Per hour"     => "hour",
               "Per month"    => "month",
               "Per year"     => "year"
             }
             
  # after_create :update_to_highrise
             
  def self.fetch_categories
    categories = Highrise::DealCategory.find(:all)
    categories.each { |cat| Category.create!(:name => cat.name, :categoryId=>cat.id)}
  end
  
  # def update_to_highrise
  #   params = {"name"=> name,"currency"=> currency,"price_type"=> deal_type,"category_id"=> category.categoryId.to_i, "party_id"=> event.lead.crm_id.to_i, "price" => how_much.to_i}
  #   Highrise::Deal.create(params)
  # end
end
