import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/cards/seller_waste_item_card.dart';

import 'cards/buyer_waste_item_card.dart';

class Store extends StatefulWidget {
  final List<bool>? filter;
  const Store({super.key, this.filter});

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
  String mode = 'seller';
  String search = '';
  CollectionReference wasteItemsCollection = FirebaseFirestore.instance.collection('wasteItems');

  Map<String, bool> filters = {'plastic': false, 'paper': false, 'electronic': false, 'metal': false};

  Stream<QuerySnapshot<Object?>> itemsStream() {
    List<String> allowedTypes = [];
    bool flag = false;
    Query<Object?> query =
        mode == 'seller' ? wasteItemsCollection.where('sellerId', isEqualTo: AuthService.user!.id) : wasteItemsCollection;

    for (var filter in filters.entries) {
      if (filter.value) {
        flag = true;
        allowedTypes.add(filter.key);
      }
    }
    if (search.isNotEmpty) {
      query = query.orderBy('title').startAt([search]).endAt(['$search\uf8ff']);
    }
    if (flag) {
      return query.where('type', whereIn: allowedTypes).snapshots();
    }
    return query.snapshots();
  }

  buyerListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return BuyerWasteItemCard(WasteItemModel.fromJSON(data));
      }).toList(),
    );
  }

  sellerListView(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
        data['id'] = document.id;
        return SellerWasteItemCard(WasteItemModel.fromJSON(data));
      }).toList(),
    );
  }

  @override
  void initState() {
    if (AuthService.user != null) {
      setState(() {
        mode = AuthService.user!.type;
      });
    }
    if (widget.filter != null) {
      setState(() {
        filters['plastic'] = widget.filter![0];
        filters['paper'] = widget.filter![1];
        filters['electronic'] = widget.filter![2];
        filters['metal'] = widget.filter![3];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            decoration: const InputDecoration(hintText: 'Search item and press Enter'),
            onSubmitted: ((value) {
              setState(() {
                search = value;
              });
              print(value);
            }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                    value: filters['plastic'],
                    onChanged: (bool? value) {
                      setState(() {
                        filters['plastic'] = value ?? false;
                      });
                    }),
                const Text(
                  'Plastic',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters['paper'],
                    onChanged: (bool? value) {
                      setState(() {
                        filters['paper'] = value ?? false;
                      });
                    }),
                const Text(
                  'Paper',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters['electronic'],
                    onChanged: (bool? value) {
                      setState(() {
                        filters['electronic'] = value ?? false;
                      });
                    }),
                const Text(
                  'e-Waste',
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            Row(
              children: [
                Checkbox(
                    value: filters['metal'],
                    onChanged: (bool? value) {
                      setState(() {
                        filters['metal'] = value ?? false;
                      });
                    }),
                const Text(
                  'Metal',
                  style: TextStyle(fontSize: 10),
                )
              ],
            )
          ],
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
              stream: itemsStream(),
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
