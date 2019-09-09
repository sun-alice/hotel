module Hotel
  class HotelBlock
    DISCOUNT_RATE = 0.5
    MAX_ROOMS = 5
    
    attr_reader :date_range, :block_rooms, :num_rooms, :room_availability, :block_number
    
    def initialize(block_number, start_date, end_date, block_rooms)
      @block_number = block_number
      @date_range = DateRange.new(start_date, end_date)
      @block_rooms = block_rooms
      @num_rooms = block_rooms.length
      @room_availability = Hash[block_rooms.collect {|room| [room, :available]}]
      
      raise StandardError, "Maximum five rooms for block." if num_rooms > MAX_ROOMS
    end
    
    def cost
      total_cost = 0
      block_rooms.each do |room|
        total_cost += date_range.nights*DISCOUNT_RATE*room.rate
      end
      
      return total_cost
    end
    
    def change_room_status_to_unavailable(requested_room)
      room_availability.each do |room, availability|
        if room == requested_room
          room_availability[room] = :unavailable
        end
      end
    end
    
    def is_room_available?(requested_room)
      room_availability.each do |room, availability|
        if room == requested_room && room_availability[room] == :unavailable
          return false
        end
      end
      return true
    end
    
    def any_available_block_rooms?
      room_availability.each_value do |availablility|
        if availablility == :available
          return true
        end
      end
      return false
    end
    
    
  end
end
