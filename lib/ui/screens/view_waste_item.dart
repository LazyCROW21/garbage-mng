import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String sellerName = 'Loading...';
  String sellerPhone = 'Loading...';
  String sellerAddress = 'Loading...';
  CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  Reference fileStorage = FirebaseStorage.instance.ref();

  @override
  void initState() {
    super.initState();
    userCollection.doc(widget.wasteItem.sellerId).get().then((value) {
      var valueMap = value.data() as Map<String, dynamic>;
      sellerName = valueMap['fullName'];
      sellerPhone = valueMap['phone'];
      sellerAddress = valueMap['address'];
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });
    fileStorage.child('files/waste_item_${widget.wasteItem.id}').getDownloadURL().then((value) {
      setState(() {
        downloadURL = value;
      });
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Waste Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              height: 480,
              margin: const EdgeInsets.all(8.0),
              child: InteractiveViewer(
                constrained: false,
                child: downloadURL != null
                    ? Image.network(downloadURL!)
                    : Image.asset(imageURL[widget.wasteItem.type] ?? defaultImg),
              ),
            ),
            const Expanded(
              child: Divider(
                height: 2,
                thickness: 2,
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
            Text(
              'Price: ${widget.wasteItem.price == 0 ? 'Free' : 'Rs. ${widget.wasteItem.price}'}',
            ),
            const SizedBox(
              height: 12,
            ),
            const Text(
              'Seller:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Name: $sellerName',
              style: const TextStyle(),
            ),
            RichText(
              text: TextSpan(text: 'Phone: ', style: const TextStyle(color: Colors.black), children: [
                TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Uri phoneno = Uri.parse('tel:$sellerPhone');
                      launchUrl(phoneno);
                    },
                  text: sellerPhone,
                  style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                )
              ]),
            ),
            Text(
              'Address: $sellerAddress',
              style: const TextStyle(),
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
                        backgroundColor: MaterialStateProperty.all(isDarkMode ? Colors.white : Colors.black),
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
