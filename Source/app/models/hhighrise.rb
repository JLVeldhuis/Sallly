require 'exceptions'
module HHighrise
  class HHighrise
    include Exceptions
    
    def leads
      Highrise::Person.find(:all)
    end
  end
end