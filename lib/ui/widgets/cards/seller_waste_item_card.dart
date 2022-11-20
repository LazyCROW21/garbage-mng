import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/common/assets_map.dart';

class SellerWasteItemCard extends StatefulWidget {
  final WasteItemModel item;

  const SellerWasteItemCard(
    this.item, {
    super.key,
  });

  @override
  State<SellerWasteItemCard> createState() => _SellerWasteItemCardState();
}

class _SellerWasteItemCardState extends State<SellerWasteItemCard> {
  String? storageImgURL;

  @override
  void initState() {
    super.initState();
    FirebaseStorage.instance.ref().child('files/waste_item_${widget.item.id}').getDownloadURL().then((value) {
      setState(() {
        storageImgURL = value;
      });
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 128,
        child: Stack(children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: storageImgURL == null
                      ? Image.asset(
                          imageURL[widget.item.type] ?? defaultImg,
                          height: 120,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.network(
                          storageImgURL!,
                          height: 120,
                          fit: BoxFit.fitHeight,
                        ),
                )),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.item.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Text(
                      'Material: ${widget.item.type}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Price: ${widget.item.price == 0 ? 'Free' : 'Rs. ${widget.item.price}'}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ))
          ]),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/addWasteItem', arguments: widget.item);
                },
                icon: const Icon(Icons.settings)),
          )
        ]),
      ),
    );
  }
}
