import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/common/validators.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/services/waste_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:garbage_mng/common/assets_map.dart';

class AddWasteItemScreen extends StatefulWidget {
  final WasteItemModel? editItem;
  final String? wasteType;
  const AddWasteItemScreen({Key? key, this.editItem, this.wasteType}) : super(key: key);

  @override
  State<AddWasteItemScreen> createState() => _AddWasteItemScreenState();
}

enum PriceModel { free, paid }

class _AddWasteItemScreenState extends State<AddWasteItemScreen> {
  bool editMode = false;
  File? imageFile;
  String? imageFirebaseURL;
  CollectionReference wasteItemModel = FirebaseFirestore.instance.collection("wasteItems");
  final wasteItem = <String, dynamic>{'title': '', 'description': '', 'type': '', 'price': 0};
  PriceModel? priceModel = PriceModel.free;

  bool isSaving = false, isDeleting = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String wasteTypeValue = '';
  // List of items in our dropdown menu
  var wasteTypes = ['plastic', 'paper', 'electronic', 'metal'];
  @override
  void initState() {
    wasteItem['sellerId'] = AuthService.user!.id;
    if (wasteTypes.isNotEmpty) {
      wasteTypeValue = wasteTypes[0];
    }
    if (widget.wasteType != null) {
      wasteTypeValue = widget.wasteType ?? wasteTypes[0];
    } else if (widget.editItem != null) {
      editMode = true;
      wasteTypeValue = widget.editItem!.type;
      String path = 'files/waste_item_${widget.editItem!.id}';
      FirebaseStorage.instance.ref().child(path).getDownloadURL().then((value) {
        setState(() {
          imageFirebaseURL = value;
        });
      }).catchError((err) {
        if (kDebugMode) {
          print(err);
        }
      });
    }
    super.initState();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera, imageQuality: 50);
      if (image == null) return;
      setState(() {
        imageFile = File(image.path);
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  addWasteItem() {
    setState(() {
      isSaving = true;
    });
    WasteItemService.addWasteItem(wasteItem, imageFile).then((value) {
      setState(() {
        isSaving = false;
      });
      if (value) {
        const snackBar = SnackBar(content: Text('Item added'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      } else {
        const snackBar = SnackBar(content: Text('Error in saving'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  updateWasteItem() {
    setState(() {
      isSaving = true;
    });
    WasteItemService.updateWasteItem(widget.editItem!.id, wasteItem, imageFile).then((value) {
      setState(() {
        isSaving = false;
      });
      if (!value) {
        const snackBar = SnackBar(content: Text('Error in saving'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  removeWasteItem() {
    setState(() {
      isDeleting = false;
    });
    WasteItemService.removeWasteItem(widget.editItem!.id).then((value) {
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

  onPriceModelChange(PriceModel? value) {
    setState(() {
      priceModel = value;
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    if (imageFile == null && imageFirebaseURL == null) {
                      return;
                    }
                    Navigator.of(context).pushNamed('/viewImage', arguments: imageFirebaseURL);
                  },
                  child: Hero(
                    tag: 'imageHero',
                    child: imageFile != null
                        ? Image.file(imageFile!)
                        : (imageFirebaseURL == null
                            ? Image.asset(imageURL[wasteTypeValue] ?? defaultImg)
                            : Image.network(imageFirebaseURL!)),
                  ),
                ),
                TextButton(
                  onPressed: () => pickImage(),
                  child: const Text(
                    'Upload Image',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  initialValue: widget.editItem == null ? '' : widget.editItem?.title,
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
                  initialValue: widget.editItem == null ? '' : widget.editItem?.description,
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
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                          child: RadioListTile(
                        value: PriceModel.free,
                        groupValue: priceModel,
                        onChanged: onPriceModelChange,
                        title: const Text('Free'),
                      )),
                      Expanded(
                        child: RadioListTile(
                          value: PriceModel.paid,
                          groupValue: priceModel,
                          onChanged: onPriceModelChange,
                          title: const Text('Paid'),
                        ),
                      )
                    ],
                  ),
                ),
                TextFormField(
                  enabled: priceModel == PriceModel.paid,
                  initialValue: widget.editItem == null ? '0' : '${widget.editItem?.price}',
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Price', prefixText: 'Rs.'),
                  validator: priceValidator,
                  onSaved: (String? inp) {
                    wasteItem['price'] = num.tryParse(inp!) ?? 0;
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
      ),
    );
  }
}
