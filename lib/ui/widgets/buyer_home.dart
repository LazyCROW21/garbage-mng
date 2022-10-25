import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:garbage_mng/common/assets_map.dart';

class BuyerHome extends StatelessWidget {
  const BuyerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('What would you like to sell today?'),
        BuyerHomeCard(
          title: 'Plastic',
          iconURL: imageURL['plastic'] ?? defaultImg,
          onTap: () {},
        ),
        BuyerHomeCard(
          title: 'Paper',
          iconURL: imageURL['paper'] ?? defaultImg,
          onTap: () {},
        ),
        BuyerHomeCard(
          title: 'e-Waste',
          iconURL: imageURL['electronic'] ?? defaultImg,
          onTap: () {},
        ),
        BuyerHomeCard(
          title: 'Metal',
          iconURL: imageURL['metal'] ?? defaultImg,
          onTap: () {},
        ),
        Expanded(
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Image.network('assets/images/recycle_bin.png')),
            const Expanded(flex: 4, child: Text('Only 25% of the total waste generated in India is collected and processed.')),
          ],
        )
      ]),
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
            leading: Image.network(
              iconURL,
              loadingBuilder: ((context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return const SizedBox(
                  height: 32,
                  width: 32,
                  child: Center(
                    child: SpinKitRing(
                      lineWidth: 3,
                      color: Colors.lightGreen,
                    ),
                  ),
                );
              }),
            ),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
