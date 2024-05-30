import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:robo_serve_mobil_app/Controllers/Abstract/AbstractController.dart';
import 'package:robo_serve_mobil_app/Entities/Product.dart';

class ProductController extends AbstractController{
  List<Product> products = [];

  Future<void> order(List<Product> products, String? table) async {
    double sum = 0.0;
    List<String> orderList = [];
    bool orderIdExists = true;
    int orderId = 0;

    // Generate a unique OrderID
    while (orderIdExists) {
      orderId = Random().nextInt(999999); // Generate a random number between 0 and 999999
      orderIdExists = await checkOrderId(orderId); // Check if the generated ID has been used before
    }

    for (Product product in products) {
      sum += product.price * product.quantity; // Multiply product price by quantity
      for (int i = 0; i < product.quantity; i++) {
        orderList.add(product.name); // Add product name to the list as many times as its quantity
      }
    }

    DatabaseReference ordersRef = FirebaseDatabase.instance.reference().child("orders").push();
    await ordersRef.set({
      'OrderID': orderId,
      'fromWhichTable': table,
      'Price': sum,
      'orderStatus': "Waiting",
      'timestamp': ServerValue.timestamp,
      'OrderList': orderList,
    });

    DatabaseReference currentlyProcessedOrderRef = FirebaseDatabase.instance.reference().child("currentlyProcessedOrder").push();
    await currentlyProcessedOrderRef.set({
      'OrderID': orderId,
      'fromWhichTable': table,
      'Price': sum,
      'orderStatus': "Waiting",
      'timestamp': ServerValue.timestamp,
      'OrderList': orderList,
    });
  }

  Future<bool> checkOrderId(int orderId) async {
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child("orders")
        .orderByChild("OrderID")
        .equalTo(orderId)
        .limitToFirst(1)
        .once()
        .then((event) => event.snapshot);

    return dataSnapshot.exists;
  }

  Future<void> fetchOrderedProducts(String tableNumber) async {
    DataSnapshot dataSnapshot = await FirebaseDatabase.instance.reference()
        .child('orders')
        .orderByChild('tableNumber')
        .equalTo(tableNumber)
        .once()
        .then((event) => event.snapshot);

    products.clear(); // Clear the products list before fetching new data

    Map<dynamic, dynamic>? ordersMap = dataSnapshot.value as Map<dynamic, dynamic>?;
    if (ordersMap != null) {
      ordersMap.forEach((key, value) {
        if (value['status'] == "Ordered") {
          List<dynamic> orders = value['ordered_items'];
          List<dynamic> orderPrices = value['ordered_item_prices'];

          for (int i = 0; i < orders.length; i++) {
            var order = orders[i];
            var orderPrice = orderPrices[i];
            products.add(new Product(order, orderPrice));
            // You can perform any desired operations with order and orderPrice here
            print('Order: $order, Price: $orderPrice');
          }
        }
      });
    }

    print("ORDERS2: ");
    print(this.products);
  }

  // Fetch food items from Firestore (unchanged)
  Future<List<Product>> fetchFoodItems() async {
    List<Product> foodItems = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Foods').get();

      querySnapshot.docs.forEach((document) {
        foodItems.add(Product.name(
            document['name'],
            document['price'].toDouble()
        ));
      });

      return foodItems;
    } catch (e) {
      print('Error fetching food items: $e');
      return foodItems;
    }
  }

  // Fetch drink items from Firestore (unchanged)
  Future<List<Product>> fetchDrinkItems() async {
    List<Product> drinkItems = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Drinks').get();
      querySnapshot.docs.forEach((document) {
        drinkItems.add(Product.name(
            document['name'],
            document['price'].toDouble()
        ));
      });

      return drinkItems;
    } catch (e) {
      print('Error fetching food items: $e');
      return drinkItems;
    }
  }

  List<Product> getProducts(){
    return this.products;
  }
}
