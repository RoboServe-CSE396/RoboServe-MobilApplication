import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:robo_serve_mobil_app/Firebase/FirebaseExample.dart';
import 'package:robo_serve_mobil_app/Firebase/firebase_options.dart';

import 'cart_page.dart'; // Import the CartPage class
import 'main_page.dart';
import "qr_scan_page.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize Flutter binding
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  /*
  ProductController productController = ProductController();
  productController.fetchOrderedProducts(1);
   */
  FirebaseExample firebaseExample = FirebaseExample();

  firebaseExample.createProductCollection();

  runApp(OrderingApp());
}

class OrderingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ordering App',
      theme: ThemeData(
        primarySwatch: Colors.blue, //color blue
      ),
      initialRoute: '/qr_scan', // Set the initial route to 'qr_scan'
      routes: {
        '/': (context) => MainPage(), // Define the main page route
        '/cart': (context) => CartPage(
            selectedFoodItems: []), // Define the cart page route with an empty list
        '/qr_scan': (context) =>
            QRScanPage(), //Qr scanner page also welcoming page
      },
    );
  }
}
