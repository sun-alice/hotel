module Hotel
  class DateRange
    attr_accessor :start_date, :end_date
    
    def initialize(start_date, end_date)
      @start_date = start_date
      @end_date = end_date
      
      raise ArgumentError, "Negative date range." if end_date < start_date 
      raise ArgumentError, "0-length date range." if end_date == start_date 
    end
    
    def overlap?(date_range)
      return date_range.start_date <= end_date && start_date <= date_range.end_date
    end
    
    def include?(date)
      return false
    end
    
    def nights
      return end_date - start_date 
    end
  end
end
