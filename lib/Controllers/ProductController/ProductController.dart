import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:robo_serve_mobil_app/Controllers/Abstract/AbstractController.dart';
import 'package:robo_serve_mobil_app/Entities/Product.dart';

class ProductController extends AbstractController{
  List<Product> products = [];


  Future<void> fetchOrderedProducts(int tableNumber) async{
    this.querySnapshot = await FirebaseFirestore.instance.collection('Orders')
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
          products.add(new Product(tableNumber, order, orderPrice));
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
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance.collection('Products').get();

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

  List<Product> getProducts(){
      return this.products;
  }
}