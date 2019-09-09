module Hotel
  class Reservation
    attr_reader :date_range, :reservation_number, :room
    # attr_accessor 
    
    def initialize(reservation_number, start_date, end_date, room)
      @reservation_number = reservation_number
      @date_range = DateRange.new(start_date, end_date)
      @room = room
    end
    
    def cost
      return date_range.nights*room.rate
    end
    
  end
end
