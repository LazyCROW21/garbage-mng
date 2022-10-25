import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/order_item_model.dart';
import 'package:garbage_mng/models/order_model.dart';
import 'package:garbage_mng/ui/widgets/cards/order_card.dart';
import 'package:garbage_mng/ui/widgets/order_details.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final Stream<QuerySnapshot> ordersQuery = FirebaseFirestore.instance.collection('orders').snapshots();

  ordersListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return OrderDetails(
          OrderModel.fromJSON(data),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            leading: null,
            title: const Text(
              'Orders',
              style: TextStyle(color: Colors.lightGreen),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<QuerySnapshot>(
                stream: ordersQuery,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Something went wrong',
                          textAlign: TextAlign.center,
                        ));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Loading",
                          textAlign: TextAlign.center,
                        ));
                  }
                  return ordersListView(snapshot);
                }),
          )),
    );
  }
}
