import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:garbage_mng/common/assets_map.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class BuyerWasteItemCard extends StatefulWidget {
  final WasteItemModel item;

  const BuyerWasteItemCard(this.item, {super.key});

  @override
  State<BuyerWasteItemCard> createState() => _BuyerWasteItemCardState();
}

class _BuyerWasteItemCardState extends State<BuyerWasteItemCard> {
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

  removeItem() {
    setState(() {
      context.read<Cart>().removeFromCart(widget.item.id);
    });
  }

  addItem() {
    setState(() {
      context.read<Cart>().addToCart(widget.item);
    });
  }

  incrementQty() {
    setState(() {
      context.read<Cart>().incrementQty(widget.item.id);
    });
  }

  decrementQty() {
    setState(() {
      context.read<Cart>().decrementQty(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/viewWasteItem', arguments: widget.item);
      },
      child: Card(
        child: SizedBox(
          height: 176,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: context.read<Cart>().cart[widget.item.id] != null
                    ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ElevatedButton(
                                  onPressed: removeItem,
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.red,
                                iconSize: 36,
                                onPressed: decrementQty,
                                icon: const Icon(Icons.remove_circle)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                '${context.watch<Cart>().cart[widget.item.id]!['qty']}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              )),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.green, iconSize: 36, onPressed: incrementQty, icon: const Icon(Icons.add_circle)),
                          )
                        ],
                      )
                    : ElevatedButton(
                        onPressed: addItem,
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(isDarkMode ? Colors.white : Colors.black),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
