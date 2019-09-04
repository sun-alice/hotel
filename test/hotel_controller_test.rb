require_relative "test_helper"

describe Hotel::HotelController do
  before do
    @hotel_controller = Hotel::HotelController.new
    @date = Date.parse("2020-08-04")
  end
  describe "wave 1" do
    describe "constructor" do
      it "can initialize a hotel controller" do
        expect(@hotel_controller).must_be_kind_of Hotel::HotelController
        expect(@hotel_controller.rooms).must_be_kind_of Array
        expect(@hotel_controller.reservations).must_be_kind_of Array
      end
    end
    
    describe "rooms" do
      it "returns and creates an array of 20 rooms" do
        expect(@hotel_controller.rooms.length).must_equal 20
        expect(@hotel_controller.rooms).must_be_kind_of Array
      end
    end
    
    describe "reserve_room" do
      before do
        @start_date = @date
        @end_date = @start_date + 3
        @reservation = @hotel_controller.reserve_room(@start_date, @end_date)
      end
      
      it "takes two Date objects and returns a Reservation" do
        expect(@reservation).must_be_kind_of Hotel::Reservation
      end
      
      it "reserves a room" do
        expect(@reservation.room).must_be_kind_of Hotel::Room
      end
      
      it "reserves the first available room" do
        expect(@reservation.room.number).must_equal 1
        
        @hotel_controller.reserve_room(@start_date, @end_date)
        test_reservation = @hotel_controller.reserve_room(@start_date, @end_date)
        
        expect(test_reservation.room.number).must_equal 3
      end
      
      it "raises a standard error if there are no rooms available" do
        19.times do
          @hotel_controller.reserve_room(@start_date, @end_date)
        end
        
        expect{(@hotel_controller.reserve_room(@start_date, @end_date))}.must_raise StandardError
      end
      
      it "can start a reservation on the same day that one ends" do
        19.times do
          @hotel_controller.reserve_room(@start_date, @end_date)
        end
        
        new_start_date = @end_date
        new_end_date = @end_date+1
        
        new_reservation = @hotel_controller.reserve_room(new_start_date, new_end_date)
        expect(new_reservation).must_be_kind_of Hotel::Reservation
      end
      
      
    end
    
    describe "reservations" do
      it "takes a Date and returns a list of Reservations" do
        reservation_list = @hotel_controller.list_of_reservations(@date)
        
        expect(reservation_list).must_be_kind_of Array
        reservation_list.each do |res|
          res.must_be_kind_of Reservation
        end
      end
      
      it "can return a list of reservations for a day" do
        start_date = @date
        end_date = start_date + 3
        @hotel_controller.reserve_room(start_date, end_date)
        @hotel_controller.reserve_room(start_date, end_date)
        
        reservation_list = @hotel_controller.list_of_reservations(@date)
        
        expect(reservation_list.length).must_equal 2
      end
      
    end
  end
  
  describe "wave 2" do
    describe "available_rooms" do
      it "takes two dates and returns a list" do
        start_date = @date
        end_date = start_date + 3
        
        room_list = @hotel_controller.available_rooms(start_date, end_date)
        
        expect(room_list).must_be_kind_of Array
      end
      
      it "returns a list of all available hotel rooms given a range" do
        start_date = @date
        end_date = start_date + 3
        
        @hotel_controller.reserve_room(start_date, end_date)
        
        available_room_list = @hotel_controller.available_rooms(start_date+1, end_date-1)
        test_available_list = @hotel_controller.available_rooms(start_date-10, end_date-10)
        expect(available_room_list.length).must_equal 19
        expect(test_available_list.length).must_equal 20
      end
      
    end
  end
end
