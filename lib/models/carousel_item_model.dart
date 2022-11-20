import 'package:flutter/material.dart';

class CarouselItemModel {
  String url;
  String body;

  CarouselItemModel({required this.url, required this.body});

  Widget toWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Expanded(flex: 1, child: Image.asset(url)), Expanded(flex: 4, child: Text(body))],
    );
  }
}
