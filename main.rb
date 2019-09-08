require_relative "lib/hotel_controller.rb"

def main
  hotel_controller = Hotel::HotelController.new
  date = Date.today
  
  should_continue = true
  menu_choices = ["1", "make a reservation", "2", "view all reservations for a date", "3", "view reservation details", "4", "view available rooms for a date range", "5", "request hotel block", "6", "reserve room in hotel block", "7", "exit"]
  
  while should_continue
    puts "\nWhat would you like to do? \n1. make a reservation \n2. view all reservations for a date \n3. view reservation details\n4. view available rooms for a date range\n5. request hotel block\n6. reserve room in hotel block\n7. exit"
    input = gets.chomp
    input = input.downcase
    
    if menu_choices.include? input
      case input
      when "1", "make a reservation" 
        start_date = nil
        end_date = nil
        
        puts "Please enter the following information:"
        puts "Reservation start date:"
        start_date = gets.chomp
        puts "Reservation end date:"
        end_date = gets.chomp
        
        start_date = Date.parse(start_date)
        end_date = Date.parse(end_date)
        
        reservation_num = hotel_controller.reserve_room(start_date, end_date)
        
        puts "Your reservation has been made. Your reservation number is #{reservation_num}."
        
      when "2", "view all reservations for a date"
        date = nil
        
        puts "Please enter the date you would like to view:"
        date = gets.chomp
        date = Date.parse(date)
        all_reservations_for_a_date = hotel_controller.list_of_reservations_for_a_date(date)
        
        puts "All the reservations for #{date}:"
        all_reservations_for_a_date.each_with_index do |res, i|
          puts "#{i+1}. Reservation ID: #{res.reservation_number}\nStart date: #{res.date_range.start_date}\nEnd date: #{res.date_range.end_date}\n"
        end
        
      when "3", "view reservation details"
        res_num = 0
        
        puts "Please enter the reservation number you would like to look up:"
        res_num = gets.chomp.to_i
        res = hotel_controller.get_res(res_num)
        
        if res != nil
          puts "Reservation #{res.reservation_number}:\nStart date: #{res.date_range.start_date}\nEnd date: #{res.date_range.end_date}\nCost: $#{res.cost.to_i}"
        else
          puts "That reservation number doesn't exist."
        end
        
      when "4", "view available rooms for a date range"
        start_date = nil
        end_date = nil
        
        puts "Please enter the following information:"
        puts "Start date:"
        start_date = gets.chomp
        puts "End date:"
        end_date = gets.chomp
        
        start_date = Date.parse(start_date)
        end_date = Date.parse(end_date)
        
        available_rooms = hotel_controller.available_rooms(start_date, end_date)
        
        if available_rooms.length != 0
          available = ""
          
          available_rooms.each do |room|
            available = available + "#{room.number}; "
          end
          
          puts "The rooms that are available on #{start_date} to #{end_date} are: "
          puts "#{available}"
        end
        
      when "5", "request hotel block"
        num_rooms = nil
        start_date = nil
        end_date = nil
        
        puts "Please enter the following information:"
        puts "Block start date:"
        start_date = gets.chomp
        puts "Block end date:"
        end_date = gets.chomp
        puts "Number of rooms:"
        num_rooms = gets.chomp.to_i
        
        start_date = Date.parse(start_date)
        end_date = Date.parse(end_date)
        
        block = hotel_controller.request_block(start_date, end_date, num_rooms)
        
        puts "Your block has been made. Your block number is #{block}."
        
      when "6", "reserve room in hotel block"
        chosen_block = nil
        chosen_room = nil
        
        puts "Please enter the hotel block you would like to reserve a room in:"
        chosen_block = gets.chomp.to_i
        puts "Please enter the room you would like to reserve:"
        chosen_room = gets.chomp.to_i
        
        chosen_room = hotel_controller.get_room(chosen_room)
        
        block_room_res = hotel_controller.reserve_block_room(chosen_block, chosen_room)
        
        puts "Your reservation has been made. Your reservation number is #{block_room_res.reservation_number}."
        
      when "7", "exit"
        puts "\nThanks for using the hotel system. Bye!"
        should_continue = false
      end
    else 
      puts "\nPlease input a valid menu choice."
    end
  end
end


main