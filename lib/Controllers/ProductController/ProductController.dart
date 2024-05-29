import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:robo_serve_mobil_app/Controllers/Abstract/AbstractController.dart';
import 'package:robo_serve_mobil_app/Entities/Product.dart';

class ProductController extends AbstractController {
  List<Product> products = [];

  Future<void> order(List<Product> products, String? table) async {
    double sum = 0.0;
    List<String> orderList = [];
    bool orderIdExists = true;
    int orderId = 0;

    // Rastgele benzersiz bir OrderID oluştur
    while (orderIdExists) {
      orderId = Random().nextInt(999999); // 0 ile 999999 arasında rastgele bir sayı üret
      orderIdExists = await checkOrderId(orderId); // Oluşturulan ID daha önce kullanılmış mı diye kontrol et
    }

    for (Product product in products) {
      sum += product.price * product.quantity; // Ürün miktarı ile çarpılıyor
      for (int i = 0; i < product.quantity; i++) {
        orderList.add(product.name); // Ürün adı miktar kadar ekleniyor
      }
    }

    DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child("orders").push();
    await ordersRef.set({
      'OrderID': orderId,
      'fromWhichTable': table,
      'Price': sum,
      'orderStatus': "Waiting",
      'timestamp': ServerValue.timestamp,
      'OrderList': orderList,
    });

    DatabaseReference currentlyProcessedOrderRef = FirebaseDatabase.instance.ref().child("currentlyProcessedOrder").push();
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
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child("orders");
    DataSnapshot snapshot = await ordersRef.orderByChild("OrderID").equalTo(orderId).limitToFirst(1).get();

    return snapshot.exists;
  }

  Future<void> fetchOrderedProducts(String tableNumber) async {
    DatabaseReference ordersRef = FirebaseDatabase.instance.ref().child('orders');
    DataSnapshot snapshot = await ordersRef.orderByChild('status').equalTo("Ordered").once();

    products.clear();
    if (snapshot.exists) {
      Map<dynamic, dynamic> ordersMap = snapshot.value as Map<dynamic, dynamic>;
      ordersMap.forEach((key, value) {
        if (value['tableNumber'] == tableNumber) {
          List<dynamic> orders = value['ordered_items'];
          List<dynamic> orderPrices = value['ordered_item_prices'];

          for (int i = 0; i < orders.length; i++) {
            var order = orders[i];
            var orderPrice = orderPrices[i];
            products.add(Product(order, orderPrice));
            // order ve orderPrice ile istediğiniz işlemi yapabilirsiniz
            print('Order: $order, Price: $orderPrice');
          }
        }
      });
    }
    print("ORDERS2: ");
    print(this.products);
  }

  // Function to fetch food items from Firebase
  Future<List<Product>> fetchFoodItems() async {
    List<Product> foodItems = [];
    try {
      DatabaseReference foodsRef = FirebaseDatabase.instance.ref().child('Foods');
      DataSnapshot snapshot = await foodsRef.once();

      if (snapshot.exists) {
        Map<dynamic, dynamic> foodsMap = snapshot.value as Map<dynamic, dynamic>;
        foodsMap.forEach((key, value) {
          foodItems.add(Product.name(
            value['name'],
            value['price'].toDouble(),
          ));
        });
      }

      return foodItems;
    } catch (e) {
      print('Error fetching food items: $e');
      return foodItems;
    }
  }

  Future<List<Product>> fetchDrinkItems() async {
    List<Product> drinkItems = [];
    try {
      DatabaseReference drinksRef = FirebaseDatabase.instance.ref().child('Drinks');
      DataSnapshot snapshot = await drinksRef.once();

      if (snapshot.exists) {
        Map<dynamic, dynamic> drinksMap = snapshot.value as Map<dynamic, dynamic>;
        drinksMap.forEach((key, value) {
          drinkItems.add(Product.name(
            value['name'],
            value['price'].toDouble(),
          ));
        });
      }

      return drinkItems;
    } catch (e) {
      print('Error fetching drink items: $e');
      return drinkItems;
    }
  }

  List<Product> getProducts() {
    return this.products;
  }
}
