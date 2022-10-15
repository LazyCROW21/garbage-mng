import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class BuyerWasteItemCard extends StatelessWidget {
  final bool inCart;
  final WasteItemModel item;

  final Map<String, String> imageURL = {
    'plastic': 'https://img.icons8.com/color/96/000000/alcohol-bottle.png',
    'paper': 'https://img.icons8.com/fluency/96/000000/paper-waste.png',
    'electronic': 'https://img.icons8.com/fluency/96/000000/electronics.png',
    'metal': 'https://img.icons8.com/fluency/96/000000/metal.png'
  };

  BuyerWasteItemCard({super.key, required this.item, required this.inCart});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/viewWasteItem', arguments: item);
      },
      child: Card(
        child: SizedBox(
          height: 176,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    inCart
                        ? Expanded(
                            child: ElevatedButton(
                                onPressed: () async {},
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'ADDED TO CART',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          )
                        : Expanded(
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                      side: const BorderSide(color: Colors.lightGreen),
                                      borderRadius: BorderRadius.circular(18.0),
                                    ))),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    'ADD TO CART',
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                )),
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
