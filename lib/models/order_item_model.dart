import 'package:garbage_mng/models/waste_item_model.dart';

class OrderItemModel {
  WasteItemModel item;
  int qty;

  OrderItemModel({required this.item, required this.qty});

  static OrderItemModel fromJSON(Map<String, dynamic> data) =>
      OrderItemModel(item: WasteItemModel.fromJSON(data['item']), qty: data['qty']);
}
