import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/common/assets_map.dart';

class ViewWasteItemScreen extends StatefulWidget {
  final WasteItemModel wasteItem;
  const ViewWasteItemScreen({Key? key, required this.wasteItem}) : super(key: key);

  @override
  State<ViewWasteItemScreen> createState() => _ViewWasteItemScreenState();
}

class _ViewWasteItemScreenState extends State<ViewWasteItemScreen> {
  CollectionReference wasteItemModel = FirebaseFirestore.instance.collection("wasteItems");
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
                  child: FadeInImage(
                    image: NetworkImage(defaultImg),
                    placeholder: AssetImage(imageURL[widget.wasteItem.type] ?? defaultImg),
                  )),
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
