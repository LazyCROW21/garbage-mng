import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:garbage_mng/ui/widgets/orders.dart';
import 'package:provider/provider.dart';
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
  List<Widget> screens = [];
  List<bool> storeFilters = [false, false, false, false];
  late TabController tabController;

  final Tab homeTab = const Tab(text: 'Home', icon: Icon(Icons.home));
  final Tab storeTab = const Tab(text: 'Store', icon: Icon(Icons.local_grocery_store));
  final Tab accountTab = const Tab(text: 'Account', icon: Icon(Icons.person));

  goTo(int index) {
    tabController.animateTo(index);
  }

  String getCartSize() {
    return '${context.watch<Cart>().cart.length}';
  }

  Widget? getFloatingActionButton() {
    switch (AuthService.user!.type) {
      case 'seller':
        if (tabController.index == 1) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/addWasteItem');
              });
        }
        break;
      case 'buyer':
        if (tabController.index == 1) {
          return FittedBox(
            child: Stack(
              alignment: const Alignment(1.4, -1.5),
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/checkout');
                  },
                  child: const Icon(Icons.shopping_cart),
                ),
                Container(
                  // This is your Badge
                  padding: const EdgeInsets.all(4),
                  constraints: const BoxConstraints(minHeight: 32, minWidth: 32),
                  decoration: BoxDecoration(
                    boxShadow: [BoxShadow(spreadRadius: 1, blurRadius: 5, color: Colors.black.withAlpha(50))],
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.green,
                  ),
                  // This is your Badge
                  child: Center(
                    child: Text('${context.watch<Cart>().cart.length}', style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          );
        }
        break;
      case 'admin':
        if (tabController.index == 3) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/editOrganisation');
              });
        }
        break;
      default:
        if (tabController.index == 3) {
          return FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/addWasteItem');
              });
        }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    switch (AuthService.user!.type) {
      case 'seller':
        tabController = TabController(length: 3, vsync: this);
        title.addAll(['Home', 'Store', 'Account']);
        tabs.addAll([homeTab, storeTab, accountTab]);
        actionMenu.addAll([
          [],
          [
            PopupMenuButton(
              itemBuilder: (content) {
                return const [PopupMenuItem<int>(value: 0, child: Text('Orders'))];
              },
              onSelected: ((value) {
                Navigator.of(context).pushNamed('/orders');
              }),
            )
          ],
          []
        ]);
        screens.addAll([
          const SellerHome(),
          const Store(),
          const Account(),
        ]);
        break;
      case 'buyer':
        tabController = TabController(length: 3, vsync: this);
        title.addAll(['Home', 'Store', 'Account']);
        actionMenu.addAll([
          [],
          [
            PopupMenuButton(
              itemBuilder: (content) {
                return const [PopupMenuItem<int>(value: 0, child: Text('Orders'))];
              },
              onSelected: ((value) {
                Navigator.of(context).pushNamed('/orders');
              }),
            )
          ],
          []
        ]);
        tabs.addAll([homeTab, storeTab, accountTab]);
        screens.addAll([
          BuyerHome(
            onTap: (String filter) {
              switch (filter) {
                case 'plastic':
                  storeFilters.setAll(0, [true, false, false, false]);
                  break;
                case 'paper':
                  storeFilters.setAll(0, [false, true, false, false]);
                  break;
                case 'electronic':
                  storeFilters.setAll(0, [false, false, true, false]);
                  break;
                case 'metal':
                  storeFilters.setAll(0, [false, false, false, true]);
                  break;
                default:
                  storeFilters.setAll(0, [false, false, false, false]);
                  break;
              }
              goTo(1);
            },
          ),
          Store(
            filter: storeFilters,
          ),
          const Account(),
        ]);
        break;
      case 'admin':
        tabController = TabController(length: 5, vsync: this);
        title.addAll(['Home', 'Store', 'Users', 'Organisations', 'Orders']);
        actionMenu.addAll([[], [], [], [], []]);
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
          const Tab(
              text: 'Ords',
              icon: Icon(
                Icons.file_present,
              ))
        ]);
        screens.addAll([
          AdminHome(
            goToCallback: goTo,
          ),
          const Store(),
          const Users(),
          const Organisations(),
          const Orders()
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
          const SellerHome(),
          const Store(),
          const Account(),
        ]);
    }

    tabController.addListener(() {
      setState(() {});
    });
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
        floatingActionButton: getFloatingActionButton(),
      ),
    );
  }
}
