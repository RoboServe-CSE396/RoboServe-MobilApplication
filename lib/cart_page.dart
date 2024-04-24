// cart_page.dart

import 'package:flutter/material.dart';
import 'package:robo_serve_mobil_app/Controllers/ProductController/ProductController.dart';

import 'Entities/Product.dart';

class CartPage extends StatelessWidget {
  final List<Product> selectedFoodItems;

  CartPage({required this.selectedFoodItems});

  @override
  Widget build(BuildContext context) {
    double totalPayment =
        selectedFoodItems.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Page'),
      ),
      body: ListView.builder(
        itemCount: selectedFoodItems.length,
        itemBuilder: (context, index) {
          final foodItem = selectedFoodItems[index];
          return ListTile(
            leading: Image.asset(
              foodItem.imagePath, // Use the imagePath property
              width: 50,
              height: 50,
            ),
            title: Text(foodItem.name),
            subtitle: Text('\$${foodItem.price.toStringAsFixed(2)}'),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
