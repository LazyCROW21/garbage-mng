import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/models/order_item_model.dart';
import 'package:garbage_mng/models/order_model.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/cards/order_card.dart';
import 'package:intl/intl.dart';

class OrderDetails extends StatefulWidget {
  final OrderModel _orderModel;
  const OrderDetails(this._orderModel, {super.key});

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');
  DateTime? orderDateTime;
  bool isCancelling = false;

  List<OrderCard> listOrderItems() {
    List<OrderCard> orderItemCards = [];
    for (OrderItemModel item in widget._orderModel.items) {
      orderItemCards.add(OrderCard(item));
    }
    return orderItemCards;
  }

  Color getStatusColor(String status) {
    Color color;
    switch (status) {
      case 'placed':
        color = Colors.blue;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      case 'confirmed':
        color = Colors.green;
        break;
      case 'delivered':
        color = Colors.purple;
        break;
      default:
        color = Colors.black;
    }
    return color;
  }

  changeOrderStatus(String status) {
    setState(() {
      isCancelling = true;
    });
    orderCollection.doc(widget._orderModel.id).update({'status': status}).then((value) {
      setState(() {
        isCancelling = false;
      });
      SnackBar snackBar = SnackBar(content: Text('Order $status'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
      setState(() {
        isCancelling = false;
      });
      SnackBar snackBar = SnackBar(content: Text('Error in $status'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future pickDateTime(BuildContext context) async {
    final initDate = DateTime.now();
    final newDate = await showDatePicker(
      context: context,
      initialDate: orderDateTime ?? initDate,
      firstDate: initDate,
      lastDate: initDate.add(const Duration(days: 45)),
    );
    if (newDate == null) return;
    final newTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(orderDateTime ?? initDate));
    if (newTime == null) return;
    setState(() {
      orderDateTime = DateTime(newDate.year, newDate.month, newDate.day, newTime.hour, newTime.minute);
    });
  }

  onReschedule() async {
    if (AuthService.user!.type == 'seller' || (AuthService.user!.type == 'buyer' && widget._orderModel.status != 'placed')) {
      return;
    }
    await pickDateTime(context);
    if (orderDateTime == null) {
      return;
    }
    try {
      await orderCollection.doc(widget._orderModel.id).update({'pickupDateTime': orderDateTime});
      if (mounted) {
        const snackBar = SnackBar(content: Text('Order rescheduled'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
      if (mounted) {
        const snackBar = SnackBar(content: Text('Error in rescheduling'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  onCancelOrder() {
    if (AuthService.user!.type == 'seller' || (AuthService.user!.type == 'buyer' && widget._orderModel.status != 'placed')) {
      return;
    }
    List<Widget> actions = [];
    String title = '';
    String content = '';
    if (AuthService.user!.type != 'admin') {
      title = 'Confirm cancellation?';
      content = 'Are you sure you want to cancel this order?';
      actions.addAll([
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Confirm');
            changeOrderStatus('cancelled');
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.red),
          ),
        )
      ]);
    } else {
      title = 'Edit order';
      content = 'Change order status';
      actions.addAll([
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Drop');
            changeOrderStatus('cancelled');
          },
          child: const Text(
            'Drop',
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Confirm');
            changeOrderStatus('confirmed');
          },
          child: const Text(
            'Confirm',
            style: TextStyle(color: Colors.green),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'Delivered');
            changeOrderStatus('delivered');
          },
          child: const Text(
            'Delivered',
            style: TextStyle(color: Colors.purple),
          ),
        )
      ]);
    }
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: actions,
            ));
  }

  @override
  Widget build(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final String formatted = formatter.format(widget._orderModel.pickupDateTime.toDate());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AuthService.user!.type == 'admin'
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Divider(
                    thickness: 4,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: RichText(
                        text: TextSpan(text: 'Order by ', style: TextStyle(color: Colors.grey[600]), children: [
                      TextSpan(
                          text: '${widget._orderModel.buyer.fullName} ',
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: '(${widget._orderModel.buyer.phone})',
                          style: TextStyle(color: Colors.blue[600]))
                    ])),
                  ),
                ],
              )
            : const Divider(
                thickness: 4,
              ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
                onLongPress: onReschedule,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RichText(
                    text: TextSpan(text: 'Order on ', style: TextStyle(color: Colors.grey[600]), children: [
                      TextSpan(text: formatted, style: TextStyle(color: isDarkMode ? Colors.black : Colors.white))
                    ]),
                  ),
                )),
            InkWell(
              onLongPress: onCancelOrder,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration:
                      BoxDecoration(color: getStatusColor(widget._orderModel.status), borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isCancelling
                          ? const Padding(
                              padding: EdgeInsets.only(right: 8.0),
                              child: SpinKitRing(
                                color: Colors.white,
                                lineWidth: 2,
                                size: 14.0,
                              ),
                            )
                          : const SizedBox.shrink(),
                      Text(
                        widget._orderModel.status,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  )),
            )
          ],
        ),
        ...listOrderItems(),
        const Divider(
          thickness: 4,
        )
      ],
    );
  }
}
