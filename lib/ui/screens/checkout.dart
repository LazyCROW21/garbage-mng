import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/common/validators.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/cards/buyer_waste_item_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CollectionReference orderCollection = FirebaseFirestore.instance.collection('orders');
  DateTime? orderDateTime;
  String orderId = '';
  bool isConfirmed = false;
  bool isCancelling = false;
  bool isRescheduling = false;
  bool isConfirming = false;

  Map<String, dynamic> orderDetails = {};

  List<Widget> renderCartItems(Map<String, Map<String, dynamic>> cart) {
    List<Widget> items = [];
    for (String id in cart.keys) {
      items.add(BuyerWasteItemCard(cart[id]!['item']));
    }
    return items;
  }

  @override
  void initState() {
    orderDetails['buyer'] = AuthService.user!.toMap();
    orderDetails['buyerId'] = AuthService.user!.id;
    orderDetails['status'] = 'placed';
    super.initState();
  }

  String getDateTimeButtonText() {
    if (orderDateTime != null) {
      return DateFormat('dd/MM/yyyy hh:mm').format(orderDateTime!);
    }
    return 'Select date & time';
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

  cancelOrder() {
    setState(() {
      isCancelling = true;
    });
    orderCollection.doc(orderId).update({'status': 'cancelled'}).then((value) {
      setState(() {
        isCancelling = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      Navigator.of(context).pushNamed('/orders');
      const snackBar = SnackBar(content: Text('Order cancelled'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
      setState(() {
        isCancelling = false;
      });
      const snackBar = SnackBar(content: Text('Error in cancelling'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  onReschedule() async {
    await pickDateTime(context);
    try {
      setState(() {
        isRescheduling = true;
      });
      await orderCollection.doc(orderId).update({'pickupDateTime': orderDateTime});
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
    setState(() {
      isRescheduling = false;
    });
  }

  onCancelOrder() {
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text('Confirm cancellation?'),
              content: const Text('Are you sure you want to cancel this order?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Confirm');
                    cancelOrder();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Order')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isConfirmed
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(child: SizedBox(height: 128, width: 128, child: Image.asset('assets/images/truck.png'))),
                  const Text(
                    'Order Confirmed',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.lightGreen, fontSize: 24),
                  ),
                  const Text(
                    'Thankyou! our representative will reach out to ou on the day of pickup',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.lightGreen, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    'You can find you pickup details under Store > Order History',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 256,
                        child: ElevatedButton(
                            onPressed: onReschedule,
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.lightGreen),
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isCancelling
                                      ? const Padding(
                                          padding: EdgeInsets.only(right: 8.0),
                                          child: SpinKitRing(
                                            color: Colors.lightGreen,
                                            lineWidth: 2,
                                            size: 18.0,
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  const Text(
                                    'Reschedule',
                                    style: TextStyle(color: Colors.lightGreen),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 256,
                        child: ElevatedButton(
                            onPressed: onCancelOrder,
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
                                    isCancelling
                                        ? const Padding(
                                            padding: EdgeInsets.only(right: 8.0),
                                            child: SpinKitRing(
                                              color: Colors.red,
                                              lineWidth: 2,
                                              size: 18.0,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    const Text(
                                      'Cancel Order',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ))),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (_) => false);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'GO TO HOME',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ))
                ],
              )
            : ListView(
                children: [
                  ...renderCartItems(context.watch<Cart>().cart),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    autofocus: true,
                    initialValue: '',
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Address', hintText: 'Enter your address here..'),
                    onChanged: (value) {
                      orderDetails['address'] = value;
                    },
                    autovalidateMode: AutovalidateMode.always,
                    validator: addressValidator,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text('Pick up date & time'),
                  TextButton(
                      onPressed: () => pickDateTime(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          getDateTimeButtonText(),
                          style: const TextStyle(fontSize: 16),
                        ),
                      )),
                  orderDateTime == null
                      ? const Text(
                          'Date & Time is required',
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: confirmOrder,
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              isConfirming
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
                                'Confirm Order',
                                style: TextStyle(color: Colors.white, fontSize: 16),
                              ),
                            ],
                          )))
                ],
              ),
      ),
    );
  }

  void confirmOrder() {
    if (context.read<Cart>().cart.isEmpty) {
      const snackBar = SnackBar(content: Text('Cart Empty'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
    if (addressValidator(orderDetails['address']) != null || orderDateTime == null) {
      return;
    }
    setState(() {
      isConfirming = true;
    });

    List<Map<String, dynamic>> items = [];
    context.read<Cart>().cart.forEach((key, value) {
      items.add({'item': value['item'].toMap(), 'qty': value['qty']});
    });
    orderDetails['items'] = items;
    orderDetails['pickupDateTime'] = orderDateTime;

    orderCollection.add(orderDetails).then((value) {
      setState(() {
        isConfirmed = true;
        isConfirming = false;
        context.read<Cart>().clearCart();
      });
      orderId = value.id;
    }).catchError((err) {
      if (kDebugMode) {
        print(err);
      }
      setState(() {
        context.read<Cart>().clearCart();
        isConfirming = false;
      });
      const snackBar = SnackBar(content: Text('Something went wrong!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
