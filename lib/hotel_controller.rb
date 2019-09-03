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
      date_range = DateRange.new(start_date, end_date)
      booked_room = @rooms.sample
      
      reservation = Reservation.new(start_date, end_date, booked_room)
      reservations << reservation
      
      return reservation
    end
    
    def list_of_reservations(date)
      total_reservations = reservations.map do |reservation|
        reservation.date_range.include? date
        [reservation]
      end
      
      return total_reservations
    end
    
    # Wave 2
    def available_rooms(start_date, end_date)
      # start_date and end_date should be instances of class Date
      return []
    end
  end
end
