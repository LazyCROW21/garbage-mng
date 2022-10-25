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
          GestureDetector(
            onTap: () {
              // goTo(2);
            },
            child: const Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.amber,
                  ),
                  title: Text('220 Users'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // goTo(3);
            },
            child: const Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.apartment,
                    color: Colors.lightGreen,
                  ),
                  title: Text('45 Organisations'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // goTo(1);
            },
            child: const Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.delete,
                    color: Colors.green,
                  ),
                  title: Text('453 Waste Items'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // goTo(0);
            },
            child: const Card(
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(
                    Icons.file_present,
                    color: Colors.blue,
                  ),
                  title: Text('112 Orders'),
                  trailing: Icon(Icons.arrow_forward_ios),
                ),
              ),
            ),
          ),
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
