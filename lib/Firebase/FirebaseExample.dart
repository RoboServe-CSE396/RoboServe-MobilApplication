import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExample {
  // Function to create a 'Product' collection and add food and beverage data
  Future<void> createProductCollection() async {
    print("BURADAYIM");
    try {
      CollectionReference foods =
      FirebaseFirestore.instance.collection('Foods');

      CollectionReference drinks =
      FirebaseFirestore.instance.collection('Drinks');

      // Add food and beverage data
      await foods.add({'name': 'Pizza', 'price': 10.0});
      await foods.add({'name': 'Hamburger', 'price': 8.0});
      await foods.add({'name': 'Pasta', 'price': 12.0});
      await foods.add({'name': 'Salad', 'price': 6.0});
      await foods.add({'name': 'Sushi', 'price': 15.0});
      await foods.add({'name': 'Steak', 'price': 20.0});
      await foods.add({'name': 'Chicken Wings', 'price': 9.0});
      await foods.add({'name': 'French Fries', 'price': 5.0});
      await foods.add({'name': 'Lasagna', 'price': 11.0});
      await foods.add({'name': 'Tacos', 'price': 7.0});
      await foods.add({'name': 'Burrito', 'price': 9.0});
      await foods.add({'name': 'Hot Dog', 'price': 4.0});
      await foods.add({'name': 'Ramen', 'price': 10.0});
      await foods.add({'name': 'Sushi Rolls', 'price': 16.0});
      await foods.add({'name': 'Caesar Salad', 'price': 7.0});
      await foods.add({'name': 'Grilled Cheese Sandwich', 'price': 6.0});
      await foods.add({'name': 'Fish and Chips', 'price': 13.0});
      await foods.add({'name': 'Spaghetti', 'price': 9.0});
      await foods.add({'name': 'Pho', 'price': 11.0});
      await foods.add({'name': 'BBQ Ribs', 'price': 18.0});
      await foods.add({'name': 'Mashed Potatoes', 'price': 5.0});
      await foods.add({'name': 'Fried Chicken', 'price': 10.0});
      await foods.add({'name': 'Meatball Sub', 'price': 8.0});
      await foods.add({'name': 'Tuna Sandwich', 'price': 7.0});
      await foods.add({'name': 'Beef Stir Fry', 'price': 12.0});
      await foods.add({'name': 'Veggie Burger', 'price': 8.0});
      await foods.add({'name': 'Nachos', 'price': 9.0});
      await foods.add({'name': 'Chicken Caesar Wrap', 'price': 7.0});
      await foods.add({'name': 'Cesar Salad', 'price': 6.0});
      await foods.add({'name': 'Clam Chowder', 'price': 10.0});
      await foods.add({'name': 'Garlic Bread', 'price': 4.0});
      await foods.add({'name': 'Cheeseburger', 'price': 9.0});
      await foods.add({'name': 'Fajitas', 'price': 12.0});
      await foods.add({'name': 'Cheesesteak Sandwich', 'price': 11.0});
      await foods.add({'name': 'Chicken Quesadilla', 'price': 8.0});
      await foods.add({'name': 'Potato Salad', 'price': 5.0});
      await foods.add({'name': 'Coleslaw', 'price': 4.0});
      await foods.add({'name': 'Buffalo Wings', 'price': 9.0});
      await foods.add({'name': 'Club Sandwich', 'price': 8.0});

      await drinks.add({'name': 'Coke', 'price': 2.0});
      await drinks.add({'name': 'Pepsi', 'price': 2.0});
      await drinks.add({'name': 'Iced Tea', 'price': 2.5});
      await drinks.add({'name': 'Lemonade', 'price': 2.5});
      await drinks.add({'name': 'Orange Juice', 'price': 3.0});
      await drinks.add({'name': 'Apple Juice', 'price': 3.0});
      await drinks.add({'name': 'Water', 'price': 1.0});
      await drinks.add({'name': 'Milk', 'price': 1.5});
      await drinks.add({'name': 'Coffee', 'price': 2.0});
      await drinks.add({'name': 'Latte', 'price': 3.0});
      await drinks.add({'name': 'Cappuccino', 'price': 3.0});
      await drinks.add({'name': 'Espresso', 'price': 2.5});
      await drinks.add({'name': 'Mocha', 'price': 3.5});
      await drinks.add({'name': 'Hot Chocolate', 'price': 3.0});
      await drinks.add({'name': 'Smoothie', 'price': 4.0});
      await drinks.add({'name': 'Mojito', 'price': 6.0});
      await drinks.add({'name': 'Margarita', 'price': 7.0});
      await drinks.add({'name': 'Soda', 'price': 2.0});
      await drinks.add({'name': 'Ginger Ale', 'price': 2.0});
      await drinks.add({'name': 'Fruit Punch', 'price': 2.5});
      print('Data added successfully');
    } catch (e) {
      print('Error adding data: $e');
    }
  }
}
