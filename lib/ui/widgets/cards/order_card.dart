import 'package:flutter/material.dart';
import 'package:garbage_mng/common/assets_map.dart';
import 'package:garbage_mng/models/order_item_model.dart';

class OrderCard extends StatelessWidget {
  final OrderItemModel _orderItemModel;
  const OrderCard(
    this._orderItemModel, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(imageURL[_orderItemModel.item.type] ?? defaultImg),
      title: Text(_orderItemModel.item.title),
      subtitle: Text(
          'Type: ${_orderItemModel.item.type} / Price: ${_orderItemModel.item.price == 0 ? 'Free' : _orderItemModel.item.price}'),
      trailing: Column(
        children: [const Text('QTY'), Text('${_orderItemModel.qty}')],
      ),
    );
  }
}
