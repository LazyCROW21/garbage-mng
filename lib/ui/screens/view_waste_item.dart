import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/common/assets_map.dart';

class ViewWasteItemScreen extends StatefulWidget {
  final WasteItemModel wasteItem;
  const ViewWasteItemScreen({Key? key, required this.wasteItem}) : super(key: key);

  @override
  State<ViewWasteItemScreen> createState() => _ViewWasteItemScreenState();
}

class _ViewWasteItemScreenState extends State<ViewWasteItemScreen> {
  String? downloadURL;
  Reference fileStorage = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
    fileStorage.child('files/waste_item_${widget.wasteItem.id}').getDownloadURL().then((value) {
      setState(() {
        downloadURL = value;
      });
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Waste Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.all(8.0),
              child: downloadURL != null
                  ? Image.network(downloadURL!)
                  : Image.asset(imageURL[widget.wasteItem.type] ?? defaultImg),
            ),
            const Expanded(
              child: Divider(
                height: 2,
                thickness: 2,
                color: Colors.black,
              ),
            ),
            Text(
              widget.wasteItem.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(widget.wasteItem.description),
            const SizedBox(
              height: 12,
            ),
            Text('Material: ${widget.wasteItem.type}'),
            const SizedBox(
              height: 12,
            ),
            const SizedBox(
              height: 12,
            ),
            context.read<Cart>().cart[widget.wasteItem.id] != null
                ? Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  context.read<Cart>().removeFromCart(widget.wasteItem.id);
                                });
                              },
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ))),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Remove',
                                  style: TextStyle(color: Colors.white, fontSize: 18),
                                ),
                              )),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            color: Colors.red,
                            iconSize: 48,
                            onPressed: () {
                              setState(() {
                                context.read<Cart>().decrementQty(widget.wasteItem.id);
                              });
                            },
                            icon: const Icon(Icons.remove_circle)),
                      ),
                      Expanded(
                          flex: 1,
                          child: Text(
                            '${context.watch<Cart>().cart[widget.wasteItem.id]!['qty']}',
                            textAlign: TextAlign.center,
                          )),
                      Expanded(
                        flex: 1,
                        child: IconButton(
                            color: Colors.green,
                            iconSize: 48,
                            onPressed: () {
                              setState(() {
                                context.read<Cart>().incrementQty(widget.wasteItem.id);
                              });
                            },
                            icon: const Icon(Icons.add_circle)),
                      )
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      setState(() {
                        context.read<Cart>().addToCart(widget.wasteItem);
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                          side: const BorderSide(color: Colors.lightGreen),
                          borderRadius: BorderRadius.circular(18.0),
                        ))),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Add To Cart',
                        style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                      ),
                    ))
          ],
        ),
      ),
    );
  }
}
