import 'package:flutter/material.dart';
import 'package:robo_serve_mobil_app/Controllers/ProductController/ProductController.dart';

import 'Entities/Product.dart';
import 'cart_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Product> foodItems = <Product>[];
  List<Product> drinkItems = <Product>[];
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
    drinkItems = await productController.fetchDrinkItems();
    setState(() {}); // State'i güncelle
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.purple[50],
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amberAccent[100],
          title: Text(
            'Order Page',
            style: TextStyle(color: Colors.deepOrange[900]),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Foods'),
              Tab(text: 'Drinks'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            foodItems.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
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
                        backgroundColor: Colors.pink,
                        animation: CurvedAnimation(
                          parent: CurvedAnimation(
                            parent: AlwaysStoppedAnimation(0.0),
                            curve: Curves.easeOut,
                          ),
                          curve: Curves.elasticOut,
                        ),
                        content: Text(
                          'Added ${foodItems[index].name} to cart',
                          style: TextStyle(fontSize: 17),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            foodItems[index].imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
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
            drinkItems.isEmpty
                ? Center(
              child: CircularProgressIndicator(),
            )
                : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: drinkItems.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFoodItems.add(drinkItems[index]);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.pink,
                        animation: CurvedAnimation(
                          parent: CurvedAnimation(
                            parent: AlwaysStoppedAnimation(0.0),
                            curve: Curves.easeOut,
                          ),
                          curve: Curves.elasticOut,
                        ),
                        content: Text(
                          'Added ${drinkItems[index].name} to cart',
                          style: TextStyle(fontSize: 17),
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Image.asset(
                            drinkItems[index].imagePath,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                drinkItems[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.0),
                              Text(
                                '\$${drinkItems[index].price.toStringAsFixed(2)}', // Display price
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
          ],
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
      ),
    );
  }
}
