module Hotel
  class DateRange
    attr_accessor :start_date, :end_date
    
    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      
      raise ArgumentError, "Negative date range." if end_date < start_date 
      raise ArgumentError, "0-length date range." if end_date == start_date 
    end
    
    def overlap?(other)
      return false
    end
    
    def include?(date)
      return false
    end
    
    def nights
      return 3
    end
  end
end
