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
        @hotel_controller.reserve_room(@start_date, @end_date)
        @reservation = @hotel_controller.reservations[0]
      end
      
      it "takes two Date objects and returns a Reservation" do
        expect(@reservation).must_be_kind_of Hotel::Reservation
      end
      
      it "reserves a room" do
        expect(@reservation.room).must_be_kind_of Hotel::Room
      end
      
      it "returns an integer (for room number)" do
        expect(@hotel_controller.reserve_room(@start_date, @end_date)).must_be_kind_of Integer
      end
      
      it "reserves the first available room" do
        expect(@reservation.room.number).must_equal 1
        
        @hotel_controller.reserve_room(@start_date, @end_date)
        @hotel_controller.reserve_room(@start_date, @end_date)
        test_res = @hotel_controller.reservations.last
        
        expect(test_res.room.number).must_equal 3
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
        
        @hotel_controller.reserve_room(new_start_date, new_end_date)
        new_reservation = @hotel_controller.reservations.last
        expect(new_reservation).must_be_kind_of Hotel::Reservation
      end
      
      it "puts the reservation in the total list of reservations" do
        expect(@hotel_controller.reservations.include? @reservation).must_equal true
      end
      
    end
    
    describe "reservations" do
      it "takes a Date and returns a list of Reservations" do
        reservation_list = @hotel_controller.list_of_reservations_for_a_date(@date)
        
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
        
        reservation_list = @hotel_controller.list_of_reservations_for_a_date(@date)
        
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
  
  describe "wave 3" do
    before do
      @start_date = @date
      @end_date = @start_date + 3
    end
    
    describe "request_block" do
      it "will return a block number" do
        expect(@hotel_controller.request_block(@start_date, @end_date, 5)).must_be_kind_of Integer
        expect(@hotel_controller.request_block(@start_date, @end_date, 5)).must_equal 2
      end
      
      it "will raise a standard error if there are not enough rooms to fulfill reservation" do
        17.times do
          @hotel_controller.reserve_room(@start_date, @end_date)
        end
        
        expect{(request_block(@start_date, @end_date, 5))}.must_raise StandardError
      end
      
      it "will add the room to the hotel block's list of rooms" do  
        @hotel_controller.request_block(@start_date, @end_date, 5)
        expect(@hotel_controller.blocks[0].num_rooms).must_equal 5
      end
      
      it "will not allow a room reservation if it is taken by a hotel block" do
        4.times do
          @hotel_controller.request_block(@start_date, @end_date, 5)
        end
        
        expect{(reserve_room(@start_date, @end_date))}.must_raise StandardError
      end
      
      it "will not allow a hotel block if it is taken by a hotel block" do
        4.times do
          @hotel_controller.request_block(@start_date, @end_date, 5)
        end
        expect{(request_block(@start_date, @end_date, 2))}.must_raise StandardError
      end
      
    end
    
    describe "reserve_block_room" do
      before do
        @block_num = @hotel_controller.request_block(@start_date, @end_date, 2)
        @hotel_block = @hotel_controller.blocks[0]
      end
      
      it "will raise an error if the block doesn't exist (is nil)" do
        test_room = Hotel::Room.new(100)
        expect{@hotel_controller.reserve_block_room(8, test_room)}.must_raise StandardError
      end
      
      it "will raise an error if that room is not in that hotel block" do
        test_room = Hotel::Room.new(100)
        expect{(@hotel_controller.reserve_block_room(@block_num, test_room))}.must_raise StandardError
      end
      
      it "will raise an error if that room is available" do
        @hotel_block.room_availability.each_key do |room|
          @hotel_controller.reserve_block_room(@block_num, room)
        end
        
        @hotel_block.room_availability.each_key do |room|
          expect{(@hotel_controller.reserve_block_room(@block_num, room))}.must_raise StandardError
        end
        
      end
      
      it "will create a reservation for the block room once the room is requested" do
        test_room = @hotel_block.room_availability.keys[0]
        expect(@hotel_controller.reserve_block_room(@block_num, test_room)).must_be_kind_of Hotel::Reservation
      end
      
      it "will put the reservation in the total list of reservations" do
        test_room = @hotel_block.room_availability.keys[0]
        test_block_reservation = @hotel_controller.reserve_block_room(@block_num, test_room)
        
        expect(@hotel_controller.reservations.include? test_block_reservation).must_equal true
      end
      
      it "will change the status of the room requested to unavailable" do
        test_room = @hotel_block.room_availability.keys[0]
        test_block_reservation = @hotel_controller.reserve_block_room(@block_num, test_room)
        
        expect(@hotel_block.room_availability.values[0]).must_equal :unavailable
      end
      
    end
    
    describe "csv methods" do
      describe "writing files" do
        before do
          @hotel_controller.rooms_csv("rooms.csv")
          @hotel_controller.blocks_csv("blocks.csv")
          @hotel_controller.reservations_csv("reservations.csv")
          
          @room_headers = ["room_number","reservations","rate"]
          @reservations_headers = ["reservation_number","start_date","end_date","room_number"]
          @blocks_headers = ["block_number","start_date","end_date","rooms_in_block","room_availability"]
        end
        
        it 'can create a room csv file' do
          expect(File.exist?("rooms.csv")).must_equal true
        end
        
        it 'can create a block csv file' do
          expect(File.exist?("blocks.csv")).must_equal true
        end
        
        it 'can create a reservations csv file' do
          expect(File.exist?("reservations.csv")).must_equal true
        end
        
        it "has the correct headers for rooms.csv" do
          CSV.read("rooms.csv", headers: true) do |line|
            @room_headers.each do |header|
              expect(line[header]).must_equal @room_headers[header]
            end
          end
        end
        
        it "has the correct headers for reservations.csv" do
          CSV.read("reservations.csv", headers: true) do |line|
            @reservations_headers.each do |header|
              expect(line[header]).must_equal @reservations_headers[header]
            end
          end
        end
        
        it "has the correct headers for blocks.csv" do
          CSV.read("blocks.csv", headers: true) do |line|
            @blocks_headers.each do |header|
              expect(line[header]).must_equal @blocks_headers[header]
            end
          end
        end
        
        it "has 20 rooms in the rooms.csv" do
          data = @hotel_controller.load_data("rooms.csv")
          expect(data.length).must_equal 20
        end
        
        it "can write a room availability into rooms.csv" do
          start_date = @date
          end_date = @start_date + 3
          @hotel_controller.reserve_room(start_date, end_date)
          @hotel_controller.rooms_csv("rooms.csv")
          data = @hotel_controller.load_data("rooms.csv")
          
          expect(data[0].values[1]).must_equal "2020-08-04 - 2020-08-07"
        end
        
        it "can write a reservation into reservation.csv" do
          start_date = @date
          end_date = @start_date + 3
          @hotel_controller.reserve_room(start_date, end_date)
          @hotel_controller.reserve_room(start_date, end_date)
          
          @hotel_controller.reservations_csv("reservations.csv")
          
          data = @hotel_controller.load_data("reservations.csv")
          
          expect(data.length).must_equal 2
        end
        
        it "can write a block into blocks.csv" do
          start_date = @date
          end_date = @start_date + 3
          @hotel_controller.request_block(@start_date, @end_date, 5)
          
          @hotel_controller.blocks_csv("blocks.csv")
          
          data = @hotel_controller.load_data("blocks.csv")
          
          expect(data.length).must_equal 1
        end
      end
      
      
    end
    
    describe "get_room & get_res" do
      it "will return a reservation object given a reservation number" do
        start_date = @date
        end_date = @start_date + 3
        @hotel_controller.reserve_room(start_date, end_date)
        found_res = @hotel_controller.get_res(1)
        
        expect(found_res).must_be_kind_of Hotel::Reservation
        expect(found_res.reservation_number).must_equal 1
      end
      
      it "will return a room object given a room number" do
        start_date = @date
        end_date = @start_date + 3
        @hotel_controller.reserve_room(start_date, end_date)
        found_room = @hotel_controller.get_room(1)
        
        expect(found_room).must_be_kind_of Hotel::Room
        expect(found_room.number).must_equal 1
      end
    end
  end
  
  
end
