import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseExample {
  // Function to create a 'Product' collection and add food and beverage data
  Future<void> createProductCollection() async {
    print("BURADAYIM");
    try {
      CollectionReference products =
      FirebaseFirestore.instance.collection('Products');

      // Add food and beverage data
      await products.add({'name': 'Pizza', 'price': 10.0});
      await products.add({'name': 'Burger', 'price': 8.0});
      await products.add({'name': 'Pasta', 'price': 12.0});
      await products.add({'name': 'Salad', 'price': 6.0});
      await products.add({'name': 'Steak', 'price': 15.0});
      await products.add({'name': 'Sushi', 'price': 20.0});
      await products.add({'name': 'Fries', 'price': 4.0});
      await products.add({'name': 'Wings', 'price': 7.0});
      await products.add({'name': 'Sandwich', 'price': 9.0});
      await products.add({'name': 'Hot Dog', 'price': 5.0});
      await products.add({'name': 'Tacos', 'price': 8.0});
      await products.add({'name': 'Nachos', 'price': 6.0});
      await products.add({'name': 'Soup', 'price': 4.0});
      await products.add({'name': 'Rice Bowl', 'price': 8.0});
      await products.add({'name': 'Curry', 'price': 10.0});
      await products.add({'name': 'Fish and Chips', 'price': 12.0});
      await products.add({'name': 'Shrimp Scampi', 'price': 14.0});
      await products.add({'name': 'Calamari', 'price': 9.0});
      await products.add({'name': 'Caesar Salad', 'price': 7.0});
      await products.add({'name': 'Greek Salad', 'price': 8.0});
      await products.add({'name': 'Cobb Salad', 'price': 9.0});
      await products.add({'name': 'Mojito', 'price': 8.0});
      await products.add({'name': 'Margarita', 'price': 9.0});
      await products.add({'name': 'Martini', 'price': 10.0});
      await products.add({'name': 'Beer', 'price': 5.0});
      await products.add({'name': 'Wine', 'price': 12.0});
      await products.add({'name': 'Soda', 'price': 2.0});
      await products.add({'name': 'Iced Tea', 'price': 3.0});
      await products.add({'name': 'Coffee', 'price': 3.0});
      await products.add({'name': 'Espresso', 'price': 4.0});
      await products.add({'name': 'Latte', 'price': 5.0});
      await products.add({'name': 'Cappuccino', 'price': 5.0});
      await products.add({'name': 'Smoothie', 'price': 6.0});
      await products.add({'name': 'Milkshake', 'price': 6.0});
      await products.add({'name': 'Juice', 'price': 4.0});
      await products.add({'name': 'Lemonade', 'price': 3.0});
      await products.add({'name': 'Milk', 'price': 2.0});
      await products.add({'name': 'Tea', 'price': 2.0});
      await products.add({'name': 'Water', 'price': 1.0});

      print('Data added successfully');
    } catch (e) {
      print('Error adding data: $e');
    }
  }
}
