require_relative 'room'
require_relative 'date_range'
require_relative 'reservation'

module Hotel
  class HotelController
    attr_reader :rooms, :reservations
    NUM_HOTEL_ROOMS = 20
    
    def initialize
      @rooms = []
      @reservations = []
      
      NUM_HOTEL_ROOMS.times do |i|
        rooms << Hotel::Room.new(i+1)
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
    
    def list_of_reservations(date)
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
      available_room = []
      
      rooms.each do |room|
        if room.availability.length == 0
          available_room << room
        else
          room.availability.each do |reservation|
            if (reservation.overlap?(date_range) == false)
              available_room << room
            end      
          end
        end
      end
      
      return available_room
    end
  end
end
