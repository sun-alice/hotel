module Hotel
  class Room
    attr_accessor :number, :availability
    
    def initialize(number, availability = [])
      @number = number
      @availability = availability
    end
    
  end
end