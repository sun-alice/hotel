## What classes does each implementation include? Are the lists the same?
Both implementations includes a CartEntry, ShoppingCart, and Order class. Although both implementations have the same classes, implementation A is tighter coupled, as it has attr_accessors in CartEntry and ShoppingCart (for :unit_price, :quantity, and :entries). This makes it possible for other classes to access those attributes.

## Write down a sentence to describe each class.
CartEntry: CartEntry holds the unit price and quantity of an entry to be added to the cart. 
ShoppingCart: ShoppingCart holds the (CartEntry) entries.
Order: Order holds a shopping cart and calculates the subtotal of the ShoppingCart entries, with sales tax.

## How do the classes relate to each other? It might be helpful to draw a diagram on a whiteboard or piece of paper.
Order is composed of a ShoppingCart, and ShoppingCart is composed of CartEntries. 

## What data does each class store? How (if at all) does this differ between the two implementations?
Both implementations store the same data-- Order storing a ShoppingCart and the sales tax percentage, ShoppingCart storing an array of CartEntries, and CartEntry storing a price and quantity of an entry.

## What methods does each class have? How (if at all) does this differ between the two implementations?
In implementation A, apart from the constructor, CartEntry and ShoppingCart has reader/writer methods for their attributes. Apart from the constructor in the Order class, Order has a total_price method that calculates the total price for the ShoppingCart.

In implementation B, there are no reader/writer methods in any of the classes. Instead, price methods are within each class.

## Consider the Order#total_price method. In each implementation: 
  ## Is logic to compute the price delegated to "lower level" classes like ShoppingCart and CartEntry, or is it retained in Order?
  In implementation A, the Order#total_price method accesses the cart entries and the entries unit_price and quantity directly-- the logic to compute the price is retained in Order. 
  
  In implementation B, it calls upon a ShoppingCart#price method to calculate the price. In this case, the logic to compute the price is delegated to the lower level classes, as each "lower level" class has its own price method used to calculate the price. The Order#total_price method simply calculates the subtotal with sales tax. 

  ## Does total_price directly manipulate the instance variables of other classes?
  In both implementations, total_price does not directly manipulate the instance variables of the other classes. Although in implementation A, the instance variables are read+write, they are only read in the total_price method, not written over or manipulated.

## If we decide items are cheaper if bought in bulk, how would this change the code? Which implementation is easier to modify?
If this functionality were added, there would need to be a method to determine a discount rate and whether or not it can be discounted. It would be easier to modify implementation B, because we could just add something in the price method to reduce the price based on the instance variable, quantity.

## Which implementation better adheres to the single responsibility principle?
Implementation B better adheres to the single responsibility principle, because each class is responsible for calculating its own price.

## Bonus question once you've read Metz ch. 3: Which implementation is more loosely coupled?
Implementation B, because the classes each have a single responsibility and attributes of a class are not accessed directly by another class.

## Identify one place in your Hotel project where a class takes on multiple roles, or directly modifies the attributes of another class. Describe in design-activity.md what changes you would need to make to improve this design, and how the resulting design would be an improvement.
In the HotelController#reserve_room method, the method directly accesses a Room object's availability and puts a date range inside the availability. HotelController is directly modifying a Room attribute. 

To change this design, I could make a method in the Room class called "add_reservation_time", which takes in a date range and adds the date range to the room's availability. With this method, the Room would be modifying it's own availability attribute, with HotelController just calling the method.

With this modification, the resulting design would be more loosely coupled. The Room class will then be in charge of keeping track of it's own availability attribute, rather than the HotelController also having a part in changing the availability attribute. The code will be easier to understand, as reading the "add_reservation_time" method call is more straightforward rather than the shovel(<<). The code will also be easier to change, should I decide to change the way availability is stored. As of right now, HotelController is assuming that the room availability is an array. However, if I wanted to change the way that room availability was stored (maybe to a hash or something), then I would have to modify the way HotelController and Room handled room availability. With the more loosely coupled design, I would only have to modify the Room method and attributes, and HotelController could still call the method to add the date range to the availability.