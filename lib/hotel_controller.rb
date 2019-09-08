require_relative 'room'
require_relative 'date_range'
require_relative 'reservation'
require_relative 'hotel_block'

module Hotel
  class HotelController
    attr_reader :rooms, :reservations, :blocks
    
    NUM_HOTEL_ROOMS = 20
    
    def initialize
      @rooms = []
      @reservations = []
      @blocks = []
      
      NUM_HOTEL_ROOMS.times do |i|
        rooms << Room.new(i+1)
      end
    end
    
    def reserve_room(start_date, end_date)
      available_rooms = available_rooms(start_date, end_date)
      
      raise StandardError, "No available rooms." if available_rooms.length == 0
      
      reservation = Reservation.new(start_date, end_date, available_rooms[0])
      reservations << reservation
      available_rooms[0].availability << reservation.date_range
      return reservation
    end
    
    def request_block(start_date, end_date, num_rooms)
      available_rooms = available_rooms(start_date, end_date)
      date_range = DateRange.new(start_date, end_date)
      
      raise StandardError, "Not enough rooms available." if num_rooms > available_rooms.length
      
      block_rooms = []
      block_number = blocks.length+1
      i = 0
      
      num_rooms.times do |i|
        block_rooms << available_rooms[i]
        available_rooms[i].availability << date_range
        i+=1
      end
      
      hotel_block = HotelBlock.new(block_number, start_date, end_date, block_rooms)
      @blocks << hotel_block
      
      return block_number
    end
    
    def reserve_block_room(block_number, requested_room)
      block = get_block(block_number)
      raise StandardError, "That block doesn't exist." if block == nil
      raise StandardError, "That room is not in this block." unless block.room_availability.has_key? requested_room
      raise StandardError, "That room is not available" if block.is_room_available?(requested_room) == false
      
      block_room_res = Reservation.new(block.date_range.start_date, block.date_range.end_date, requested_room)
      reservations <<  block_room_res
      block.change_room_status_to_unavailable(requested_room)
      
      return block_room_res
    end
    
    def list_of_reservations_for_a_date(date)
      total_reservations = []
      
      reservations.each do |reservation|
        if reservation.date_range.include?(date) 
          total_reservations << reservation
        end
      end
      
      return total_reservations
    end
    
    def available_rooms(start_date, end_date)
      date_range = DateRange.new(start_date, end_date)
      available_rooms = []
      
      rooms.each do |room|
        if room.availability.length == 0
          available_rooms << room
        else
          room.availability.each do |reservation|
            if (reservation.overlap?(date_range) == false)
              available_rooms << room
            end      
          end
        end
      end
      
      return available_rooms
    end
    
    private
    
    def get_block(find_this_block_number)
      found_block = nil
      
      blocks.each do |block|
        if block.block_number == find_this_block_number
          found_block = block
        end
      end
      
      return found_block
    end
  end
end
