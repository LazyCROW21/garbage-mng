import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:garbage_mng/common/assets_map.dart';
import 'package:garbage_mng/models/waste_item_model.dart';

class BuyerWasteItemCard extends StatefulWidget {
  final WasteItemModel item;

  const BuyerWasteItemCard(this.item, {super.key});

  @override
  State<BuyerWasteItemCard> createState() => _BuyerWasteItemCardState();
}

class _BuyerWasteItemCardState extends State<BuyerWasteItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/viewWasteItem', arguments: widget.item);
      },
      child: Card(
        child: SizedBox(
          height: 176,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(children: [
                Expanded(
                    flex: 1,
                    child: FadeInImage(
                      image: AssetImage(defaultImg),
                      placeholder: AssetImage(imageURL[widget.item.type] ?? defaultImg),
                    )),
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          widget.item.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          'Material: ${widget.item.type}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Stock: ${widget.item.stock}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ))
              ]),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: context.read<Cart>().cart[widget.item.id] != null
                    ? Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12.0),
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      context.read<Cart>().removeFromCart(widget.item.id);
                                    });
                                  },
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18.0),
                                      ))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text(
                                      'Remove',
                                      style: TextStyle(color: Colors.white, fontSize: 14),
                                    ),
                                  )),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.red,
                                iconSize: 36,
                                onPressed: () {
                                  setState(() {
                                    context.read<Cart>().decrementQty(widget.item.id);
                                  });
                                },
                                icon: const Icon(Icons.remove_circle)),
                          ),
                          Expanded(
                              flex: 1,
                              child: Text(
                                '${context.watch<Cart>().cart[widget.item.id]}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 14),
                              )),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                                color: Colors.green,
                                iconSize: 36,
                                onPressed: () {
                                  setState(() {
                                    context.read<Cart>().incrementQty(widget.item.id);
                                  });
                                },
                                icon: const Icon(Icons.add_circle)),
                          )
                        ],
                      )
                    : ElevatedButton(
                        onPressed: () {
                          setState(() {
                            context.read<Cart>().addToCart(widget.item.id);
                          });
                        },
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                              side: const BorderSide(color: Colors.lightGreen),
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            'ADD TO CART',
                            style: TextStyle(color: Colors.lightGreen),
                          ),
                        )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
