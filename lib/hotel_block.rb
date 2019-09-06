module Hotel
  class HotelBlock
    DISCOUNT_RATE = 0.5
    MAX_ROOMS = 5
    COST_PER_NIGHT = 200
    
    attr_reader :date_range, :block_rooms
    attr_accessor :num_rooms, :room_availability
    
    def initialize(start_date, end_date, block_rooms)
      @date_range = Hotel::DateRange.new(start_date, end_date)
      @block_rooms = block_rooms
      @num_rooms = block_rooms.length
      @room_availability = Hash[block_rooms.collect {|room| [room, :available]}]
      
      raise StandardError, "Maximum five rooms for block." if num_rooms > MAX_ROOMS
    end
    
    def cost
      return date_range.nights*COST_PER_NIGHT*DISCOUNT_RATE*num_rooms
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
          raise StandardError, "That room is unavailable." 
        end
      end
    end
    
    def any_available_block_rooms?
      room_availability.each_value do |availablility|
        if availablility == :available
          return true
        else
          return false
        end
      end
    end
    
    
  end
end
