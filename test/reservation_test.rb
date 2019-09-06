require_relative "test_helper"

describe Hotel::Reservation do
  
  describe "constructor" do
    it "Can be initialized" do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      room = 1
      reservation = Hotel::Reservation.new(start_date, end_date, room)
      
      expect(reservation).must_be_instance_of Hotel::Reservation
    end
  end
  
  describe "cost" do
    before do
      @start_date = Date.new(2017, 01, 01)
      @end_date = @start_date + 3
      @room = Hotel::Room.new(1)
      @reservation = Hotel::Reservation.new(@start_date, @end_date, @room)
    end
    
    it "returns a number" do
      expect(@reservation.cost).must_be_kind_of Numeric
    end
    
    it "returns a correct price" do
      expect(@reservation.cost).must_equal 600
    end
    
  end
end
