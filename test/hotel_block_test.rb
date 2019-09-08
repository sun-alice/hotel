require_relative "test_helper"

describe Hotel::HotelBlock do
  before do
    @rooms = []
    i = 0
    2.times do
      room = Hotel::Room.new(i)
      @rooms << room
      i+=1
    end
  end
  
  describe "constructor" do
    it "Can be initialized" do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      block_rooms = @rooms
      
      hotel_block = Hotel::HotelBlock.new(1, start_date, end_date, block_rooms)
      
      expect(hotel_block).must_be_instance_of Hotel::HotelBlock
    end
  end
  
  describe "hotel block methods" do
    before do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      @hotel_block = Hotel::HotelBlock.new(1, start_date, end_date, @rooms)
    end
    
    describe "cost" do
      it "returns a number" do
        expect(@hotel_block.cost).must_be_kind_of Numeric
      end
      
      it "returns a discounted rate" do
        expect(@hotel_block.cost).must_equal 600
      end
    end
    
    describe "any_available_block_rooms?" do
      it "will return true if there are rooms available" do
        expect(@hotel_block.any_available_block_rooms?).must_equal true
        
        @hotel_block.change_room_status_to_unavailable(@rooms[0])
        
        expect(@hotel_block.any_available_block_rooms?).must_equal true
      end
      
      it "will return false if there are no rooms available" do
        @hotel_block.room_availability.update(@hotel_block.room_availability) {|key, value| value = :unavailable}
        
        expect(@hotel_block.any_available_block_rooms?).must_equal false
      end
    end
    
    describe "change_room_status_to_unavailable" do
      it "will change a room status to unavailable" do
        @hotel_block.room_availability.each_key do |room|
          @hotel_block.change_room_status_to_unavailable(room)
        end
        
        expect(@hotel_block.any_available_block_rooms?).must_equal false
      end
    end
    
    describe "is_room_available?" do
      it "will return false if that room requested is not available" do
        @hotel_block.room_availability.each_key do |room|
          @hotel_block.change_room_status_to_unavailable(room)
          expect(@hotel_block.is_room_available?(room)).must_equal false
        end
      end
      
      it "will return true if that room requested is available" do
        @hotel_block.room_availability.each_key do |room|
          expect(@hotel_block.is_room_available?(room)).must_equal true
        end
      end
    end
    
  end
  
end
