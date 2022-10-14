import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item.dart';
import 'package:garbage_mng/ui/widgets/seller_waste_item_card.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  final Stream<QuerySnapshot> wasteItemsQuery = FirebaseFirestore.instance.collection('wasteItems').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: wasteItemsQuery,
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

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              data['id'] = document.id;
              return SellerWasteItemCard(
                item: WasteItem.fromJSON(data),
              );
            }).toList(),
          );
        });
  }
}
