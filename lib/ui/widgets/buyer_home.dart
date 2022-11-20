import 'package:flutter/material.dart';
import 'package:garbage_mng/common/assets_map.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:garbage_mng/models/carousel_item_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

typedef ChangeTabCallback = void Function(String);

class BuyerHome extends StatefulWidget {
  final ChangeTabCallback onTap;
  const BuyerHome({super.key, required this.onTap});

  @override
  State<BuyerHome> createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  int activeIndex = 0;
  List<CarouselItemModel> carouselItems = [
    CarouselItemModel(
        url: 'assets/images/recycle_bin.png',
        body: 'Only 25% of the total waste generated in India is collected and processed.'),
    CarouselItemModel(
        url: 'assets/images/recycle_bin.png',
        body: 'Only 25% of the total waste generated in India is collected and processed.'),
    CarouselItemModel(
        url: 'assets/images/recycle_bin.png',
        body: 'Only 25% of the total waste generated in India is collected and processed.')
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          CarouselSlider.builder(
            options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                }),
            itemCount: carouselItems.length,
            itemBuilder: (context, index, realIndex) {
              return carouselItems[index].toWidget(context);
            },
          ),
          Center(
              child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: carouselItems.length,
            effect: const JumpingDotEffect(dotColor: Colors.lightGreen, dotWidth: 8, dotHeight: 8),
          )),
          const SizedBox(
            height: 18,
          ),
          const Text('What would you like to buy today?'),
          BuyerHomeCard(
            title: 'Plastic',
            iconURL: imageURL['plastic'] ?? defaultImg,
            onTap: () {
              widget.onTap('plastic');
            },
          ),
          BuyerHomeCard(
            title: 'Paper',
            iconURL: imageURL['paper'] ?? defaultImg,
            onTap: () {
              widget.onTap('paper');
            },
          ),
          BuyerHomeCard(
            title: 'e-Waste',
            iconURL: imageURL['electronic'] ?? defaultImg,
            onTap: () {
              widget.onTap('electronic');
            },
          ),
          BuyerHomeCard(
            title: 'Metal',
            iconURL: imageURL['metal'] ?? defaultImg,
            onTap: () {
              widget.onTap('metal');
            },
          ),
          // Expanded(
          //   child: Container(),
          // ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Expanded(flex: 1, child: Image.asset('assets/images/recycle_bin.png')),
          //     const Expanded(flex: 4, child: Text('Only 25% of the total waste generated in India is collected and processed.')),
          //   ],
          // )
        ]),
      ),
    );
  }
}

class BuyerHomeCard extends StatelessWidget {
  final String title;
  final String iconURL;
  final VoidCallback onTap;
  const BuyerHomeCard({super.key, required this.title, required this.iconURL, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Image.asset(iconURL),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
