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
      it "takes two Date objects and returns a Reservation" do
        start_date = @date
        end_date = start_date + 3
        
        reservation = @hotel_controller.reserve_room(start_date, end_date)
        
        expect(reservation).must_be_kind_of Hotel::Reservation
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
        reservation = @hotel_controller.reserve_room(start_date, end_date)
        reservation = @hotel_controller.reserve_room(start_date, end_date)
        
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
    end
  end
end
