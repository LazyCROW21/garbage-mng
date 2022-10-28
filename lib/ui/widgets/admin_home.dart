import 'package:flutter/material.dart';

typedef GoToCallback = void Function(int index);

class AdminHome extends StatelessWidget {
  final GoToCallback goToCallback;
  const AdminHome({super.key, required this.goToCallback});

  Widget adminHomeCard(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              icon,
              color: Colors.amber,
            ),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AdminHomeCard(
              title: '220 Users',
              icon: Icons.person,
              color: Colors.amber,
              onTap: () {
                goToCallback(2);
              }),
          AdminHomeCard(
              title: '45 Organisations',
              icon: Icons.apartment,
              color: Colors.lightGreen,
              onTap: () {
                goToCallback(3);
              }),
          AdminHomeCard(
              title: '453 Waste Items',
              icon: Icons.delete,
              color: Colors.green,
              onTap: () {
                goToCallback(1);
              }),
          AdminHomeCard(
              title: '112 Orders',
              icon: Icons.file_present,
              color: Colors.blue,
              onTap: () {
                goToCallback(4);
              }),
        ],
      ),
    );
  }
}

class AdminHomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const AdminHomeCard({super.key, required this.title, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            leading: Icon(
              icon,
              color: color,
            ),
            title: Text(title),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
        ),
      ),
    );
  }
}
