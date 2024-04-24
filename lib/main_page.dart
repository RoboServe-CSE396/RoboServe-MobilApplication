import 'package:flutter/material.dart';
import 'package:robo_serve_mobil_app/Controllers/ProductController/ProductController.dart';
import 'package:robo_serve_mobil_app/Firebase/FirebaseExample.dart';

import 'cart_page.dart';
import 'Entities/Product.dart';

void main() {
  runApp(MainPage());
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> foodItems = <Product>[];
  List<Product> selectedFoodItems = [];

  @override
  void initState() {
    super.initState();
    fetchFoodItems();
  }

  void fetchFoodItems() async {
    // Firebase'den yiyecek ve içecek verilerini çek
    ProductController productController = ProductController();
    foodItems = await productController.fetchFoodItems();
    setState(() {}); // State'i güncelle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
      ),
      body: foodItems.isEmpty // Veriler henüz yüklenmediyse
          ? Center(child: CircularProgressIndicator()) // Yükleme göstergesi göster
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: foodItems.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedFoodItems.add(foodItems[index]);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Added ${foodItems[index].name} to cart'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Card(
              elevation: 3.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          foodItems[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                        Text(
                          '\$${foodItems[index].price.toStringAsFixed(2)}', // Display price
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CartPage(selectedFoodItems: selectedFoodItems),
            ),
          );
        },
        label: Text('View Cart'),
        icon: Icon(Icons.shopping_cart),
      ),
    );
  }
}
