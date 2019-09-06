module Hotel
  class Reservation
    attr_reader :date_range
    attr_accessor :room
    
    def initialize(start_date, end_date, room)
      @date_range = Hotel::DateRange.new(start_date, end_date)
      @room = room
    end
    
    def cost
      return date_range.nights*room.cost_per_night
    end
    
  end
end
