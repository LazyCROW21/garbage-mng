import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:garbage_mng/ui/widgets/cards/buyer_waste_item_card.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  CollectionReference wasteItemsCollection = FirebaseFirestore.instance.collection('wasteItems');
  DateTime? orderDateTime;
  bool isConfirmed = true;

  Future<List<Widget>> renderCartItems(Map<String, int> cart) async {
    List<Widget> items = [];
    for (String id in cart.keys) {
      var doc = await wasteItemsCollection.doc(id).get();
      var data = doc.data()! as Map<String, dynamic>;
      data['id'] = id;
      print(data);
      items.add(BuyerWasteItemCard(WasteItemModel.fromJSON(data)));
    }
    return items;
  }

  @override
  void initState() {
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
                  Center(child: SizedBox(height: 128, width: 128, child: Image.asset('images/truck.png'))),
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
                            onPressed: () {},
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.lightGreen),
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                'Reschedule',
                                style: TextStyle(color: Colors.lightGreen),
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
                            onPressed: () {
                              Navigator.of(context).pushReplacementNamed('/login');
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.white),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                  side: const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(18.0),
                                ))),
                            child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Cancel Order',
                                  style: TextStyle(color: Colors.red),
                                ))),
                      ),
                    ],
                  ),
                  Expanded(child: Container()),
                  ElevatedButton(
                      onPressed: () {},
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
                  FutureBuilder(
                      future: renderCartItems(context.watch<Cart>().cart),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Column(
                            children: snapshot.data ?? const [Text('Error')],
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SpinKitRing(color: Colors.lightGreen, lineWidth: 4),
                          );
                        }
                      }),
                  const SizedBox(
                    height: 12,
                  ),
                  TextFormField(
                    initialValue: '',
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Address', hintText: 'Enter your address here..'),
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
                  const SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ))),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Confirm Order',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ))
                ],
              ),
      ),
    );
  }
}
