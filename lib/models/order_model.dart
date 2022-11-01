import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:garbage_mng/models/order_item_model.dart';
import 'package:garbage_mng/models/user_model.dart';

class OrderModel {
  String id;
  String buyerId;
  UserModel buyer;
  List<OrderItemModel> items;
  String address;
  Timestamp pickupDateTime;
  String status;

  OrderModel(
      {required this.id,
      required this.buyerId,
      required this.buyer,
      required this.items,
      required this.address,
      required this.pickupDateTime,
      required this.status});

  static OrderModel fromJSON(Map<String, dynamic> data) => OrderModel(
      id: data['id'],
      buyerId: data['buyerId'],
      buyer: UserModel.fromJSON(data['buyer']),
      items: (data['items'] as List).map((e) => OrderItemModel.fromJSON(e)).toList(),
      address: data['address'],
      pickupDateTime: data['pickupDateTime'],
      status: data['status']);
}
