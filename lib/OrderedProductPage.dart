import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Entities/Product.dart';

class OrderedProductPage extends StatefulWidget {
  final List<Product> selectedFoodItems;
  final String table;
  OrderedProductPage({required this.selectedFoodItems, required this.table});

  @override
  _OrderedProductPageState createState() => _OrderedProductPageState();
}

class _OrderedProductPageState extends State<OrderedProductPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Ordered Products'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('fromWhichTable',
            whereIn: widget.selectedFoodItems
                .map((item) => widget.table)
                .toList())
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Card(
                child: ListTile(
                  title: Text('Order ID: ${document['OrderID']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Table: ${document['fromWhichTable']}'),
                      Text('Price: \$${document['Price']}'),
                      Text('Status: ${document['orderStatus']}'),
                      SizedBox(height: 10),
                      Text(
                        'Items:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.selectedFoodItems.map((item) {
                          return Text(
                            '- ${item.name} - \$${item.price.toStringAsFixed(2)}',
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
