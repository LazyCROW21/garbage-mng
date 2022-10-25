import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/common/assets_map.dart';

class SellerWasteItemCard extends StatefulWidget {
  final WasteItemModel item;

  const SellerWasteItemCard({super.key, required this.item});

  @override
  State<SellerWasteItemCard> createState() => _SellerWasteItemCardState();
}

class _SellerWasteItemCardState extends State<SellerWasteItemCard> {
  String imgPath = 'https://img.icons8.com/fluency/96/000000/waste--v1.png';

  @override
  void initState() {
    // FirebaseStorage.instance.ref().child('files/waste_item_${widget.item.id}').getDownloadURL().then((value) {
    //   imgPath = value;
    //   print(value);
    // });
    super.initState();
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
                child: FadeInImage(
                  image: NetworkImage(imgPath),
                  placeholder: AssetImage(imageURL[widget.item.type] ?? defaultImg),
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
                      'Stock: ${widget.item.stock}',
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
