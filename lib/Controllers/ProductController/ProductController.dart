import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:robo_serve_mobil_app/Controllers/Abstract/AbstractController.dart';
import 'package:robo_serve_mobil_app/Entities/Product.dart';

class ProductController extends AbstractController{
  List<Product> products = [];

/*
  void addPersonToDatabase(String name, int age) {
    DatabaseReference peopleRef =
    FirebaseDatabase.instance.reference().child('orders');
    List<String> orderList = ["su","tatli","kebap"];
    Map<String, dynamic> personMap = {
      'OrderID': 2,
      'OrderList': orderList,
      'Price' : 200,
      'FromWhichTable' : 'Table1',
      'OrderStatus' : 'Ordered',
    };
    peopleRef.push().set(personMap);
  }

  void fetch(){
    DatabaseReference starCountRef =
    FirebaseDatabase.instance.ref('Orders');
    starCountRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print("VALUES:");
      print(data.toString());
    });


  }
 */

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

    await FirebaseFirestore.instance.collection("orders").add({
      'OrderID': orderId,
      'fromWhichTable': table,
      'Price': sum,
      'orderStatus': "Waiting",
      'timestamp': Timestamp.now(),
      'OrderList': orderList,
    });

    await FirebaseFirestore.instance.collection("currentlyProcessedOrder").add({
      'OrderID': orderId,
      'fromWhichTable': table,
      'Price': sum,
      'orderStatus': "Waiting",
      'timestamp': Timestamp.now(),
      'OrderList': orderList,
    });
  }

  Future<bool> checkOrderId(int orderId) async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection("orders")
        .where("OrderID", isEqualTo: orderId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }




  Future<void> fetchOrderedProducts(String tableNumber) async{
    this.querySnapshot = await FirebaseFirestore.instance.collection('orders')
        .where('status', isEqualTo: "Ordered")
        .where('tableNumber', isEqualTo: tableNumber)
        .get();

    for (var documentSnapshot in this.querySnapshot.docs) {
      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        List<dynamic> orders = data['ordered_items'];
        List<dynamic> orderPrices = data['ordered_item_prices'];

        for (int i = 0; i < orders.length; i++) {
          var order = orders[i];
          var orderPrice = orderPrices[i];
          products.add(new Product(order, orderPrice));
          // order ve orderPrice ile istediğiniz işlemi yapabilirsiniz
          print('Order: $order, Price: $orderPrice');
        }
      }
    }
    print("ORDERS2: ");
    print(this.products);
  }

  // Function to fetch food items from Firebase
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