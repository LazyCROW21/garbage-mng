import 'package:flutter/material.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/account.dart';
import 'package:garbage_mng/ui/widgets/admin_home.dart';
import 'package:garbage_mng/ui/widgets/buyer_home.dart';
import 'package:garbage_mng/ui/widgets/organisations.dart';
import 'package:garbage_mng/ui/widgets/seller_home.dart';
import 'package:garbage_mng/ui/widgets/store.dart';
import 'package:garbage_mng/ui/widgets/users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  List<Tab> tabs = [];
  List<String> title = [];
  List<List<Widget>> actionMenu = [];
  List<FloatingActionButton?> floatingActionButton = [];
  List<Widget> screens = [];
  late TabController tabController;

  final Tab homeTab = const Tab(text: 'Home', icon: Icon(Icons.home));
  final Tab storeTab = const Tab(text: 'Store', icon: Icon(Icons.local_grocery_store));
  final Tab accountTab = const Tab(text: 'Account', icon: Icon(Icons.person));

  goTo(int index) {
    tabController.animateTo(index);
  }

  @override
  void initState() {
    switch (AuthService.user!.type) {
      case 'seller':
        tabController = TabController(length: 3, vsync: this);
        title.addAll(['Home', 'Store', 'Account']);
        tabs.addAll([homeTab, storeTab, accountTab]);
        actionMenu.addAll([
          [],
          [
            PopupMenuButton(itemBuilder: (content) {
              return const [PopupMenuItem<int>(value: 0, child: Text('Orders'))];
            })
          ],
          []
        ]);
        screens.addAll([
          SellerHome(),
          const Store(),
          const Account(),
        ]);
        floatingActionButton.addAll([
          null,
          FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/addWasteItem');
              }),
          null,
        ]);
        break;
      case 'buyer':
        tabController = TabController(length: 3, vsync: this);
        title.addAll(['Home', 'Store', 'Account']);
        actionMenu.addAll([
          [],
          [
            PopupMenuButton(itemBuilder: (content) {
              return const [PopupMenuItem<int>(value: 0, child: Text('Orders'))];
            })
          ],
          []
        ]);
        tabs.addAll([homeTab, storeTab, accountTab]);
        screens.addAll([
          BuyerHome(),
          const Store(),
          const Account(),
        ]);
        floatingActionButton.addAll([
          null,
          null,
          null,
        ]);
        break;
      case 'admin':
        tabController = TabController(length: 4, vsync: this);
        title.addAll(['Home', 'Store', 'Users', 'Organisations']);
        actionMenu.addAll([[], [], [], []]);
        tabs.addAll([
          homeTab,
          storeTab,
          const Tab(
            text: 'Users',
            icon: Icon(Icons.people),
          ),
          const Tab(
            text: 'Orgs',
            icon: Icon(Icons.apartment),
          ),
        ]);
        screens.addAll([
          AdminHome(
            goToCallback: goTo,
          ),
          const Store(),
          const Users(),
          const Organisations(),
        ]);
        floatingActionButton.addAll([
          null,
          null,
          null,
          FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/editOrganisation');
              }),
        ]);
        break;
      default:
        tabController = TabController(length: 3, vsync: this);
        tabs.addAll([
          homeTab,
          storeTab,
          accountTab,
        ]);
        screens.addAll([
          SellerHome(),
          const Store(),
          const Account(),
        ]);
        floatingActionButton.addAll([
          null,
          FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/addWasteItem');
              }),
          null,
        ]);
    }
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(border: Border(top: BorderSide(color: Colors.grey))),
          child: TabBar(
            controller: tabController,
            labelColor: Colors.lightGreen,
            unselectedLabelColor: Colors.grey,
            tabs: tabs,
          ),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: null,
          title: Text(
            title[tabController.index],
            style: const TextStyle(color: Colors.lightGreen),
          ),
          actions: actionMenu[tabController.index],
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: TabBarView(
          controller: tabController,
          children: screens,
        ),
        floatingActionButton: floatingActionButton[tabController.index],
      ),
    );
  }
}
