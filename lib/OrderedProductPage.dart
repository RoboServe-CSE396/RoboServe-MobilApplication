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
            .collection('currentlyProcessedOrder')
            .where('fromWhichTable', isEqualTo: widget.table)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              if (document['orderStatus'] != 'Delivered') {
                List<dynamic> orderList = document['OrderList'];
                Map<String, int> itemCountMap = {};
                orderList.forEach((item) {
                  if (itemCountMap.containsKey(item)) {
                    itemCountMap[item] = itemCountMap[item]! + 1;
                  } else {
                    itemCountMap[item] = 1;
                  }
                });
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
                          children: itemCountMap.entries.map((entry) {
                            return Text(
                              '- ${entry.key} x${entry.value}',
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    trailing: document['orderStatus'] == 'Arrived'
                        ? IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Order Received?"),
                              content: Text(
                                  "Have you received the order?"),
                              actions: [
                                TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    // Mark order as received
                                    markOrderAsReceived(
                                        document.id);
                                    Navigator.of(context).pop();
                                    // Close the app
                                    Navigator.of(context)
                                        .popUntil((route) => route.isFirst);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                        : null,
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            }).toList(),
          );
        },
      ),
    );
  }

  void markOrderAsReceived(String orderId) {
    FirebaseFirestore.instance
        .collection('currentlyProcessedOrder')
        .doc(orderId)
        .update({'orderStatus': 'Delivered'});
  }
}
