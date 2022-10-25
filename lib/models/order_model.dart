import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbage_mng/models/order_item_model.dart';

class OrderModel {
  String id;
  String buyer;
  List<OrderItemModel> items;
  String address;
  Timestamp dateTime;
  String status;

  OrderModel(
      {required this.id,
      required this.buyer,
      required this.items,
      required this.address,
      required this.dateTime,
      required this.status});

  static OrderModel fromJSON(Map<String, dynamic> data) => OrderModel(
      id: data['id'],
      buyer: data['buyer'],
      items: (data['items'] as List).map((e) => OrderItemModel.fromJSON(e)).toList(),
      address: data['address'],
      dateTime: data['dateTime'],
      status: data['status']);
}
