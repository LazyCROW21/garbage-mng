import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class SellerWasteItemCard extends StatelessWidget {
  final WasteItemModel item;

  final Map<String, String> imageURL = {
    'plastic': 'https://img.icons8.com/color/96/000000/alcohol-bottle.png',
    'paper': 'https://img.icons8.com/fluency/96/000000/paper-waste.png',
    'electronic': 'https://img.icons8.com/fluency/96/000000/electronics.png',
    'metal': 'https://img.icons8.com/fluency/96/000000/metal.png'
  };

  SellerWasteItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 128,
        child: Stack(children: [
          Row(children: [
            Expanded(
                flex: 1,
                child: Image.network(item.imgURL == ''
                    ? (imageURL[item.type] ?? 'https://img.icons8.com/fluency/96/000000/waste--v1.png')
                    : item.imgURL)),
            Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const Divider(
                      color: Colors.black,
                    ),
                    Text(
                      'Material: ${item.type}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Stock: ${item.stock}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      'Price: ${item.price}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ))
          ]),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/addWasteItem', arguments: item);
                },
                icon: const Icon(Icons.settings)),
          )
        ]),
      ),
    );
  }
}
