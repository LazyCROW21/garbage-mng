import 'package:flutter/material.dart';
import 'package:garbage_mng/ui/widgets/account.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey))),
            child: const TabBar(
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.local_grocery_store)),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.home),
              Icon(Icons.local_grocery_store),
              Account(),
            ],
          ),
        ),
      ),
    );
  }
}
