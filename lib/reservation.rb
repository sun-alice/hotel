module Hotel
  class Reservation
    attr_reader :date_range, :id
    attr_accessor :room
    
    COST_PER_NIGHT = 200
    
    def initialize(start_date, end_date, room)
      @date_range = Hotel::DateRange.new(start_date, end_date)
      @room = room
    end
    
    def cost
      return date_range.nights*COST_PER_NIGHT
    end
    
  end
end
