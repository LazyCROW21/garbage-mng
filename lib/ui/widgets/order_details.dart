import 'package:flutter/material.dart';
import 'package:garbage_mng/models/order_item_model.dart';
import 'package:garbage_mng/models/order_model.dart';
import 'package:garbage_mng/ui/widgets/cards/order_card.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel _orderModel;
  const OrderDetails(this._orderModel, {super.key});

  List<OrderCard> listOrderItems() {
    List<OrderCard> orderItemCards = [];
    print(_orderModel.items);
    for (OrderItemModel item in _orderModel.items) {
      orderItemCards.add(OrderCard(item));
    }
    return orderItemCards;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          thickness: 4,
        ),
        Text('Order on ${_orderModel.dateTime}'),
        ...listOrderItems(),
        const Divider(
          thickness: 4,
        )
      ],
    );
  }
}
