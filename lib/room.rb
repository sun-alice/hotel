module Hotel
  class Room
    attr_reader :number, :availability, :rate
    
    COST_PER_NIGHT = 200
    
    def initialize(number, availability = [], rate: COST_PER_NIGHT)
      @number = number
      @availability = availability
      @rate = rate
    end
    
  end
end