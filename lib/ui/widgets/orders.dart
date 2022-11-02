import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/order_model.dart';
import 'package:garbage_mng/ui/widgets/order_details.dart';

class Orders extends StatelessWidget {
  Orders({super.key});
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<QuerySnapshot>(
          stream: ordersCollection.orderBy('pickupDateTime', descending: true).snapshots(),
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
    );
  }
}
