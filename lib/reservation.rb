module Hotel
  class Reservation
    attr_accessor :start_date, :end_date, :room
    
    def initialize(start_date, end_date, room)
      @date_range = Hotel::DateRange.new(start_date, end_date)
      @room = room
    end
    
    def cost
      
      return 3
    end
  end
end
