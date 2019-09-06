require_relative "test_helper"

describe Hotel::DateRange do
  describe "constructor" do
    it "Can be initialized with two dates" do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date + 3
      
      range = Hotel::DateRange.new(start_date, end_date)
      
      expect(range.start_date).must_equal start_date
      expect(range.end_date).must_equal end_date
    end
    
    it "is an an error for negative-length ranges" do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date - 3
      
      expect{Hotel::DateRange.new(start_date, end_date)}.must_raise ArgumentError
    end
    
    it "is an error to create a 0-length range" do
      start_date = Date.new(2017, 01, 01)
      end_date = start_date 
      
      expect{Hotel::DateRange.new(start_date, end_date)}.must_raise ArgumentError
    end
  end
  
  describe "overlap?" do
    before do
      @start_date = Date.new(2017, 01, 01)
      @end_date = @start_date + 3
      
      @range = Hotel::DateRange.new(@start_date, @end_date)
    end
    
    it "returns true for the same range" do
      test_range = Hotel::DateRange.new(@start_date, @end_date)
      expect(@range.overlap?(test_range)).must_equal true
    end
    
    it "returns true for a contained range" do
      test_range = Hotel::DateRange.new(@start_date+1, @end_date-1)
      expect(@range.overlap?(test_range)).must_equal true
    end
    
    it "returns true for a range that overlaps in front" do
      test_range = Hotel::DateRange.new(@start_date-1, @end_date-1)
      expect(@range.overlap?(test_range)).must_equal true
    end
    
    it "returns true for a range that overlaps in the back" do
      test_range = Hotel::DateRange.new(@start_date+1, @end_date+1)
      expect(@range.overlap?(test_range)).must_equal true
    end
    
    it "returns true for a containing range" do
      test_range = Hotel::DateRange.new(@start_date-1, @end_date+1)
      expect(@range.overlap?(test_range)).must_equal true
    end
    
    it "returns false for a range starting on the end_date date" do
      test_range = Hotel::DateRange.new(@end_date, @end_date+1)
      expect(@range.overlap?(test_range)).must_equal false
    end
    
    it "returns false for a range ending on the start_date date" do
      test_range = Hotel::DateRange.new(@start_date-1, @start_date)
      expect(@range.overlap?(test_range)).must_equal false
    end
    
    it "returns false for a range completely before" do
      test_range = Hotel::DateRange.new(@start_date-3, @start_date-1)
      expect(@range.overlap?(test_range)).must_equal false
    end
    
    it "returns false for a date completely after" do
      test_range = Hotel::DateRange.new(@end_date+5, @end_date+7)
      expect(@range.overlap?(test_range)).must_equal false
    end
  end
  
  describe "include?" do
    before do
      @start_date = Date.new(2017, 01, 01)
      @end_date = @start_date + 3
      
      @range = Hotel::DateRange.new(@start_date, @end_date)
    end
    
    it "returns false if the date is clearly out" do
      test_date = @start_date-5
      expect(@range.include?(test_date)).must_equal false
    end
    
    it "returns true for dates in the range" do
      test_date = @start_date+1
      expect(@range.include?(test_date)).must_equal true
    end
    
    it "returns false for the end_date date" do
      test_date = @end_date
      expect(@range.include?(test_date)).must_equal false
    end
  end
  
  describe "nights" do
    it "returns the correct number of nights" do
      @start_date = Date.new(2017, 01, 01)
      @end_date = @start_date + 3
      @range = Hotel::DateRange.new(@start_date, @end_date)
      
      expect(@range.nights).must_equal 3
    end
  end
end
