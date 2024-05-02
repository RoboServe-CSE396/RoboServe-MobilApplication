import 'package:flutter/material.dart';
import 'package:robo_serve_mobil_app/Controllers/ProductController/ProductController.dart';
import 'package:robo_serve_mobil_app/OrderedProductPage.dart';
import 'package:robo_serve_mobil_app/main_page.dart';
import 'package:robo_serve_mobil_app/qr_scan_page.dart';

import 'Entities/Product.dart';

class CartPage extends StatefulWidget {
  final List<Product> selectedFoodItems;
  final String table;
  CartPage({required this.selectedFoodItems, required this.table});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Confirm"),
      onPressed: () {
        Navigator.pop(context);
        ProductController().order(widget.selectedFoodItems, widget.table);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrderedProductPage(selectedFoodItems: widget.selectedFoodItems, table: widget.table,)),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Order Confirmation"),
      content: Text("You are about to complete your Order. Are you sure?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // calculates totalPayment before buying.
  late double totalPayment =
      widget.selectedFoodItems.fold(0, (sum, item) => sum + item.price);

  // removes items from cart
  void removeItem(Product item) {
    setState(() {
      widget.selectedFoodItems.remove(item);
      totalPayment =
          widget.selectedFoodItems.fold(0, (sum, item) => sum + item.price);
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
          '${item.name} removed from cart',
          style: TextStyle(fontSize: 17),
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void buyItems() {
    setState(() {
      showAlertDialog(context);
      /*SnackBar(
        content: Text("Enjoy your meal"),
      );*/
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[50],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.purple[100],
        title: Text(
          'Cart Page',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.selectedFoodItems.length,
        itemBuilder: (context, index) {
          final foodItem = widget.selectedFoodItems[index];
          return Column(
            children: [
              Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      foodItem.imagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(foodItem.name),
                      Text('\$${foodItem.price.toStringAsFixed(2)}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      removeItem(foodItem);
                    },
                  ),
                ),
              ),
              Divider(),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[100],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Total Payment: \$${totalPayment.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[500]),
              onPressed: buyItems,
              child: Text('Buy', style: TextStyle(color: Colors.black87)),
            ),
          ],
        ),
      ),
    );
  }
}
