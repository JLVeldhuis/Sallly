class Deal < ActiveRecord::Base
  attr_accessor :highrised
  
  belongs_to :event
  belongs_to :category
  
  DEALTYPE = {
               "Fixed bid"    => "fixed",
               "Per hour"     => "hour",
               "Per month"    => "month",
               "Per year"     => "year"
             }
             
  after_save :update_to_highrise
             
  def self.fetch_categories
    categories = Highrise::DealCategory.find(:all)
    categories.each { |cat| Category.create!(:name => cat.name, :categoryId=>cat.id)}
  end
  
  def update_to_highrise
    if highrised
      ddeal     = Highrise::Deal.find(dealId) unless dealId.blank?
      params    = {"name"=> name, "currency"=> currency, "price_type"=> deal_type, "category_id"=> category.categoryId.to_i, "price" => how_much.to_i}
      
      params["party_id"]    = event.lead.crm_id.to_i if event.lead
      params["category_id"] = category.categoryId.to_i if category.categoryId
      
      if ddeal
        # params["id"]  = dealId
        # response      = ddeal.update_attributes(params)
      else
        response      = Highrise::Deal.create(params)
      end
      parseResp(response)
    end
  end
  
  def parseResp(res)
    if res.errors.messages.empty?
      self.update_attributes(:dealId => res.id, :highrised => false)
      return true
    else
      res.errors.messages.each_with_key do |k, e|
        self.errors.add(k, e)
      end
      return false
    end
  end
end
