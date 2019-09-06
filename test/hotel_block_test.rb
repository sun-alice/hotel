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
      
      hotel_block = Hotel::HotelBlock.new(start_date, end_date, block_rooms)
      
      expect(hotel_block).must_be_instance_of Hotel::HotelBlock
    end
  end
  
  describe "cost" do
    before do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      @hotel_block = Hotel::HotelBlock.new(start_date, end_date, @rooms)
    end
    
    it "returns a number" do
      expect(@hotel_block.cost).must_be_kind_of Numeric
    end
    
    it "returns a discounted rate" do
      expect(@hotel_block.cost).must_equal 600
    end
  end
  
  describe "any_available_block_rooms?" do
    before do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      @hotel_block = Hotel::HotelBlock.new(start_date, end_date, @rooms)
    end
    
    it "will return true if there are rooms available" do
      expect(@hotel_block.any_available_block_rooms?).must_equal true
    end
    
    it "will return false if there are no rooms available" do
      @hotel_block.room_availability.each do |room|
        room["status"] = :unavailable
      end
      
      expect(@hotel_block.any_available_block_rooms?).must_equal false
    end
  end
  
end
