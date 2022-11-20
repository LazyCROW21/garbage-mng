import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class WasteItemService {
  static CollectionReference wasteItemCollection = FirebaseFirestore.instance.collection("wasteItems");
  static Future<bool> addWasteItem(wasteItem, imageFile) async {
    try {
      DocumentReference doc = await WasteItemService.wasteItemCollection.add(wasteItem);
      if (imageFile != null) {
        String path = 'files/waste_item_${doc.id}';
        await FirebaseStorage.instance.ref().child(path).putFile(imageFile!);
      }
      return true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }

  static Future<bool> updateWasteItem(id, wasteItem, imageFile) async {
    try {
      await WasteItemService.wasteItemCollection.doc(id).update(wasteItem);
      if (imageFile != null) {
        String path = 'files/waste_item_$id';
        await FirebaseStorage.instance.ref().child(path).putFile(imageFile!);
      }
      return true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }

  static Future<bool> removeWasteItem(id) async {
    try {
      await WasteItemService.wasteItemCollection.doc(id).delete();
      String path = 'files/waste_item_$id';
      FirebaseStorage.instance.ref().child(path).delete();
      return true;
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      return false;
    }
  }
}
