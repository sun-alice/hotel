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
      #find the room, put that date range in the room's availability array
      # start_date and end_date should be instances of class Date
      return Reservation.new(start_date, end_date, nil)
    end
    
    def reservations(date)
      #get reservations for date
      return []
    end
    
    # Wave 2
    def available_rooms(start_date, end_date)
      # start_date and end_date should be instances of class Date
      return []
    end
  end
end
