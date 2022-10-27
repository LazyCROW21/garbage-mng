import 'package:flutter/material.dart';
import 'package:garbage_mng/models/order_item_model.dart';
import 'package:garbage_mng/models/order_model.dart';
import 'package:garbage_mng/ui/widgets/cards/order_card.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatelessWidget {
  final OrderModel _orderModel;
  const OrderDetails(this._orderModel, {super.key});

  List<OrderCard> listOrderItems() {
    List<OrderCard> orderItemCards = [];
    for (OrderItemModel item in _orderModel.items) {
      orderItemCards.add(OrderCard(item));
    }
    return orderItemCards;
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(_orderModel.dateTime.toDate());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(
          thickness: 4,
        ),
        Text('Order on $formatted'),
        ...listOrderItems(),
        const Divider(
          thickness: 4,
        )
      ],
    );
  }
}
