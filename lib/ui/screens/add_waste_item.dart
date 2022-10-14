import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/models/waste_item.dart';

class AddWasteItemScreen extends StatefulWidget {
  final WasteItem? editItem;
  const AddWasteItemScreen({Key? key, this.editItem}) : super(key: key);

  @override
  State<AddWasteItemScreen> createState() => _AddWasteItemScreenState();
}

class _AddWasteItemScreenState extends State<AddWasteItemScreen> {
  bool editMode = false;
  CollectionReference wasteItemModel = FirebaseFirestore.instance.collection("wasteItems");

  final wasteItem = <String, dynamic>{'title': '', 'description': '', 'type': '', 'stock': 0, 'price': 0.0, 'imgURL': ''};

  bool isSaving = false, isDeleting = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String wasteTypeValue = '';
  // List of items in our dropdown menu
  var wasteTypes = ['plastic', 'paper', 'electronic', 'metal'];

  @override
  void initState() {
    if (wasteTypes.isNotEmpty) {
      wasteTypeValue = wasteTypes[0];
    }
    if (widget.editItem != null) {
      editMode = true;
      wasteTypeValue = widget.editItem!.type;
    }
    super.initState();
  }

  String? titleValidator(String? inp) {
    if (inp == null) {
      return 'Title is required';
    } else if (inp.length < 3 || inp.length > 64) {
      return 'Title must be 3 to 64 characters';
    }
    return null;
  }

  String? descriptionValidator(String? inp) {
    if (inp == null) {
      return 'Description is required';
    } else if (inp.length < 3 || inp.length > 256) {
      return 'Description must be 3 to 256 characters';
    }
    return null;
  }

  String? stockValidator(String? inp) {
    if (inp == null) {
      return 'Stock is required';
    } else {
      int? inpInt = int.tryParse(inp);
      if (inpInt == null || inpInt <= 0) {
        return 'Stock must be integer greater than 0';
      }
    }
    return null;
  }

  String? priceValidator(String? inp) {
    if (inp == null) {
      return 'Price is required';
    } else {
      double? inpInt = double.tryParse(inp);
      if (inpInt == null || inpInt <= 0) {
        return 'Price must be number greater than 0';
      }
    }
    return null;
  }

  addWasteItem() {
    wasteItemModel.add(wasteItem).then((DocumentReference doc) {
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Item added'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
    }).catchError((err) {
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  updateWasteItem() {
    wasteItemModel.doc(widget.editItem!.id).update(wasteItem).then((value) {
      setState(() {
        isSaving = false;
      });
    }).catchError((err) {
      setState(() {
        isSaving = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  removeWasteItem() {
    setState(() {
      isDeleting = false;
    });
    wasteItemModel.doc(widget.editItem!.id).delete().then((value) {
      setState(() {
        isDeleting = false;
      });
      Navigator.of(context).pop();
      const snackBar = SnackBar(content: Text('Item removed'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      setState(() {
        isDeleting = false;
      });
      const snackBar = SnackBar(content: Text('Error in saving'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${editMode ? 'Edit' : 'Add'} Waste Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: widget.editItem?.title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: titleValidator,
                onSaved: (String? inp) {
                  wasteItem['title'] = inp ?? '';
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: widget.editItem?.description,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 4,
                validator: descriptionValidator,
                onSaved: (String? inp) {
                  wasteItem['description'] = inp ?? '';
                },
              ),
              const SizedBox(
                height: 12,
              ),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Waste Type'),
                value: wasteTypeValue,
                items:
                    wasteTypes.map((String wasteType) => DropdownMenuItem(value: wasteType, child: Text(wasteType))).toList(),
                icon: const Icon(Icons.keyboard_arrow_down),
                onChanged: (String? newValue) {
                  setState(() {
                    wasteTypeValue = newValue!;
                  });
                },
                onSaved: (String? inp) {
                  wasteItem['type'] = inp ?? '';
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: '${widget.editItem?.stock}',
                decoration: const InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                validator: stockValidator,
                onSaved: (String? inp) {
                  wasteItem['stock'] = int.tryParse(inp ?? '0') ?? 0;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: '${widget.editItem?.price}',
                decoration: const InputDecoration(labelText: 'Price'),
                validator: priceValidator,
                keyboardType: TextInputType.number,
                onSaved: (String? inp) {
                  wasteItem['price'] = double.tryParse(inp ?? '0') ?? 0.0;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                initialValue: widget.editItem?.imgURL,
                decoration: const InputDecoration(labelText: 'Image URL'),
                onSaved: (String? inp) {
                  wasteItem['imgURL'] = inp ?? '';
                },
              ),
              const SizedBox(
                height: 12,
              ),
              ElevatedButton(
                  onPressed: () {
                    bool? isValid = formKey.currentState?.validate();
                    if (isValid == null || isValid == false) {
                      return;
                    }
                    formKey.currentState?.save();
                    setState(() {
                      isSaving = true;
                    });
                    if (editMode) {
                      updateWasteItem();
                    } else {
                      addWasteItem();
                    }
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isSaving
                            ? const Padding(
                                padding: EdgeInsets.only(right: 8.0),
                                child: SpinKitRing(
                                  color: Colors.white,
                                  lineWidth: 2,
                                  size: 18.0,
                                ),
                              )
                            : const SizedBox.shrink(),
                        Text(
                          editMode ? 'Save' : 'Add',
                          style: const TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(
                height: 12,
              ),
              editMode
                  ? ElevatedButton(
                      onPressed: () {
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Confirm delete?'),
                                  content: const Text('Are you sure you want to delete this item?'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context, 'Delete');
                                        removeWasteItem();
                                      },
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ));
                      },
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(18.0),
                          ))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            isDeleting
                                ? const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: SpinKitRing(
                                      color: Colors.white,
                                      lineWidth: 2,
                                      size: 18.0,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const Text(
                              'Remove',
                              style: TextStyle(color: Colors.red, fontSize: 18),
                            ),
                          ],
                        ),
                      ))
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }
}
