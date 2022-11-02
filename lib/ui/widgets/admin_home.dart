import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

typedef GoToCallback = void Function(int index);

class AdminHome extends StatefulWidget {
  final GoToCallback goToCallback;
  const AdminHome({super.key, required this.goToCallback});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final CollectionReference ordersCollection = FirebaseFirestore.instance.collection('orders');

  final CollectionReference wasteItemsCollection = FirebaseFirestore.instance.collection('wasteItems');

  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot<Object?>>(
              stream: usersCollection.where('type', isEqualTo: 'seller').snapshots(),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  count = snapshot.data!.docs.length;
                }
                return AdminHomeCard(
                    title: '$count Users',
                    icon: Icons.person,
                    color: Colors.amber,
                    onTap: () {
                      widget.goToCallback(2);
                    });
              }),
          StreamBuilder<QuerySnapshot<Object?>>(
              stream: usersCollection.where('type', isEqualTo: 'buyer').snapshots(),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  count = snapshot.data!.docs.length;
                }
                return AdminHomeCard(
                    title: '$count Organisations',
                    icon: Icons.apartment,
                    color: Colors.lightGreen,
                    onTap: () {
                      widget.goToCallback(3);
                    });
              }),
          StreamBuilder<QuerySnapshot<Object?>>(
              stream: wasteItemsCollection.snapshots(),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  count = snapshot.data!.docs.length;
                }
                return AdminHomeCard(
                    title: '$count Waste Items',
                    icon: Icons.delete,
                    color: Colors.green,
                    onTap: () {
                      widget.goToCallback(1);
                    });
              }),
          StreamBuilder<QuerySnapshot<Object?>>(
              stream: ordersCollection.snapshots(),
              builder: (context, snapshot) {
                int count = 0;
                if (snapshot.hasData) {
                  count = snapshot.data!.docs.length;
                }
                return AdminHomeCard(
                    title: '$count Orders',
                    icon: Icons.file_present,
                    color: Colors.blue,
                    onTap: () {
                      widget.goToCallback(4);
                    });
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
