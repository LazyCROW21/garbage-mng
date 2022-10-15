import 'package:flutter/material.dart';
import 'package:garbage_mng/ui/widgets/account.dart';
import 'package:garbage_mng/ui/widgets/organisations.dart';
import 'package:garbage_mng/ui/widgets/store.dart';
import 'package:garbage_mng/ui/widgets/user_profile.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;



  @override
  Widget build(BuildContext context) {
    List<FloatingActionButton?> floatingActionButton = [null,FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
      Navigator.of(context).pushNamed('/addWasteItem');
    }),null,FloatingActionButton(child: const Icon(Icons.add), onPressed: () {
      Navigator.of(context).pushNamed('/editOrganisation');
    }),null];
    return SafeArea(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey))),
            child: TabBar(
              onTap: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              labelColor: Colors.lightGreen,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.home)),
                Tab(icon: Icon(Icons.local_grocery_store)),
                Tab(icon: Icon(Icons.people),),
                Tab(icon: Icon(Icons.apartment),),
                Tab(icon: Icon(Icons.person)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.home),
              Store(),
              UserProfile(),
              Organisations(),
              Account(),
            ],
          ),
          floatingActionButton: floatingActionButton[selectedIndex],
        ),
      ),
    );
  }
}
