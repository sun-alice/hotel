module Hotel
  class Room
    attr_accessor :number, :availability
    attr_reader :cost_per_night
    
    COST_PER_NIGHT = 200
    
    def initialize(number, availability = [])
      @number = number
      @availability = availability
      @cost_per_night = COST_PER_NIGHT
    end
    
  end
end