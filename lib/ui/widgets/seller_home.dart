import 'package:flutter/material.dart';
import 'package:garbage_mng/common/assets_map.dart';

class SellerHome extends StatelessWidget {
  const SellerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const Text('What would you like to sell today?'),
        SellerHomeCard(
          title: 'Plastic',
          iconURL: imageURL['plastic'] ?? defaultImg,
          onTap: () {
            Navigator.of(context).pushNamed('/addWasteItem', arguments: 'plastic');
          },
        ),
        SellerHomeCard(
          title: 'Paper',
          iconURL: imageURL['paper'] ?? defaultImg,
          onTap: () {
            Navigator.of(context).pushNamed('/addWasteItem', arguments: 'paper');
          },
        ),
        SellerHomeCard(
          title: 'e-Waste',
          iconURL: imageURL['electronic'] ?? defaultImg,
          onTap: () {
            Navigator.of(context).pushNamed('/addWasteItem', arguments: 'electronic');
          },
        ),
        SellerHomeCard(
          title: 'Metal',
          iconURL: imageURL['metal'] ?? defaultImg,
          onTap: () {
            Navigator.of(context).pushNamed('/addWasteItem', arguments: 'metal');
          },
        ),
        Expanded(
          child: Container(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(flex: 1, child: Image.asset('assets/images/recycle_bin.png')),
            const Expanded(flex: 4, child: Text('Only 25% of the total waste generated in India is collected and processed.')),
          ],
        )
      ]),
    );
  }
}

class SellerHomeCard extends StatelessWidget {
  final String title;
  final String iconURL;
  final VoidCallback onTap;
  const SellerHomeCard({super.key, required this.title, required this.iconURL, required this.onTap});

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
            trailing: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
