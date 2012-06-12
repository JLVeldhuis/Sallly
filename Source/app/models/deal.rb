class Deal < ActiveRecord::Base
  belongs_to :event
  
  DEALTYPE = {
               "Fixed bid"    => "fixed",
               "Per hour"     => "hour",
               "Per month"    => "month",
               "Per year"     => "year"
             }
             
  def self.fetch_categories
    categories = Highrise::DealCategory.find(:all)
    categories.each { |cat| Category.create!(:name => cat.name, :categoryId=>cat.id)}
  end
end
