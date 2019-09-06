module Hotel
  class Room
    attr_accessor :number, :availability, :rate
    attr_reader :cost_per_night
    
    COST_PER_NIGHT = 200
    
    def initialize(number, availability = [], rate: COST_PER_NIGHT)
      @number = number
      @availability = availability
      @cost_per_night = COST_PER_NIGHT
      @rate = rate
    end
    
  end
end