import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/cards/seller_waste_item_card.dart';

import 'cards/buyer_waste_item_card.dart';

class Store extends StatefulWidget {
  const Store({super.key});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  String mode = 'seller';
  final Stream<QuerySnapshot> wasteItemsQuery = FirebaseFirestore.instance.collection('wasteItems').snapshots();

  // Plastic - Paper - E-waste - Metal
  List<bool> filters = [false, false, false, false];

  buyerListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return BuyerWasteItemCard(
          item: WasteItemModel.fromJSON(data),
          inCart: false,
        );
      }).toList(),
    );
  }

  sellerListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return SellerWasteItemCard(
          item: WasteItemModel.fromJSON(data),
        );
      }).toList(),
    );
  }

  @override
  void initState() {
    if (AuthService.user != null) {
      mode = AuthService.user!.type;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Checkbox(
                    value: filters[0],
                    onChanged: (bool? value) {
                      setState(() {
                        filters[0] = value ?? false;
                      });
                    }),
                const Text(
                  'Plastic',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters[1],
                    onChanged: (bool? value) {
                      setState(() {
                        filters[1] = value ?? false;
                      });
                    }),
                const Text(
                  'Paper',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters[2],
                    onChanged: (bool? value) {
                      setState(() {
                        filters[2] = value ?? false;
                      });
                    }),
                const Text(
                  'e-Waste',
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters[3],
                    onChanged: (bool? value) {
                      setState(() {
                        filters[3] = value ?? false;
                      });
                    }),
                const Text(
                  'Metal',
                  style: TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
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
                return mode == 'buyer' ? buyerListView(snapshot) : sellerListView(snapshot);
              }),
        ),
      ],
    );
  }
}
