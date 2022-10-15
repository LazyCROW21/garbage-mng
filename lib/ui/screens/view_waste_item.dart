import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class ViewWasteItemScreen extends StatefulWidget {
  final WasteItemModel wasteItem;
  const ViewWasteItemScreen({Key? key, required this.wasteItem}) : super(key: key);

  @override
  State<ViewWasteItemScreen> createState() => _ViewWasteItemScreenState();
}

class _ViewWasteItemScreenState extends State<ViewWasteItemScreen> {
  CollectionReference wasteItemModel = FirebaseFirestore.instance.collection("wasteItems");
  final Map<String, String> imageURL = {
    'plastic': 'https://img.icons8.com/color/96/000000/alcohol-bottle.png',
    'paper': 'https://img.icons8.com/fluency/96/000000/paper-waste.png',
    'electronic': 'https://img.icons8.com/fluency/96/000000/electronics.png',
    'metal': 'https://img.icons8.com/fluency/96/000000/metal.png'
  };
  bool inCart = false;
  int qty = 0;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String wasteTypeValue = '';
  // List of items in our dropdown menu
  var wasteTypes = ['plastic', 'paper', 'electronic', 'metal'];

  @override
  void initState() {
    wasteTypeValue = widget.wasteItem.type;
    super.initState();
  }

  addWasteItemToCart() {
    // wasteItemModel.add(wasteItem).then((DocumentReference doc) {
    //   setState(() {
    //     isSaving = false;
    //   });
    //   const snackBar = SnackBar(content: Text('Item added'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   Navigator.of(context).pop();
    // }).catchError((err) {
    //   setState(() {
    //     isSaving = false;
    //   });
    //   const snackBar = SnackBar(content: Text('Error in saving'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // });
  }

  updateWasteItemQty() {
    // wasteItemModel.doc(widget.editItem!.id).update(wasteItem).then((value) {
    //   setState(() {
    //     isSaving = false;
    //   });
    // }).catchError((err) {
    //   setState(() {
    //     isSaving = false;
    //   });
    //   const snackBar = SnackBar(content: Text('Error in saving'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // });
  }

  removeWasteItemFromCart() {
    // setState(() {
    //   isDeleting = false;
    // });
    // wasteItemModel.doc(widget.editItem!.id).delete().then((value) {
    //   setState(() {
    //     isDeleting = false;
    //   });
    //   Navigator.of(context).pop();
    //   const snackBar = SnackBar(content: Text('Item removed'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // }).catchError((err) {
    //   setState(() {
    //     isDeleting = false;
    //   });
    //   const snackBar = SnackBar(content: Text('Error in saving'));
    //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Waste Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Image.network(widget.wasteItem.imgURL == ''
                      ? (imageURL[widget.wasteItem.type] ?? 'https://img.icons8.com/fluency/96/000000/waste--v1.png')
                      : widget.wasteItem.imgURL)),
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
              Text(
                'Stock: ${widget.wasteItem.stock}',
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Price: ${widget.wasteItem.price}',
              ),
              const SizedBox(
                height: 12,
              ),
              inCart
                  ? Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  inCart = false;
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
                                  qty -= 1;
                                });
                              },
                              icon: const Icon(Icons.remove_circle)),
                        ),
                        Expanded(
                            flex: 1,
                            child: Text(
                              '$qty',
                              textAlign: TextAlign.center,
                            )),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                              color: Colors.green,
                              iconSize: 48,
                              onPressed: () {
                                setState(() {
                                  qty += 1;
                                });
                              },
                              icon: const Icon(Icons.add_circle)),
                        )
                      ],
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setState(() {
                          inCart = true;
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
      ),
    );
  }
}
