import 'package:flutter/material.dart';
import 'package:garbage_mng/services/auth.dart';
import 'package:garbage_mng/ui/widgets/account.dart';
import 'package:garbage_mng/ui/widgets/organisations.dart';
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
  List<FloatingActionButton?> floatingActionButton = [];
  List<Widget> screens = [];
  late TabController tabController;

  @override
  void initState() {
    switch (AuthService.user!.type) {
      case 'seller':
        tabController = TabController(length: 3, vsync: this);
        title.addAll(['Home', 'Store', 'Account']);
        tabs.addAll(const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.local_grocery_store)),
          Tab(icon: Icon(Icons.person)),
        ]);
        screens.addAll(const [
          Icon(Icons.home),
          Store(),
          Account(),
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
        tabs.addAll(const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.local_grocery_store)),
          Tab(icon: Icon(Icons.person)),
        ]);
        screens.addAll(const [
          Icon(Icons.home),
          Store(),
          Account(),
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
        tabs.addAll(const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.local_grocery_store)),
          Tab(
            icon: Icon(Icons.people),
          ),
          Tab(
            icon: Icon(Icons.apartment),
          ),
        ]);
        screens.addAll(const [
          Icon(Icons.home),
          Store(),
          Users(),
          Organisations(),
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
        tabs.addAll(const [
          Tab(icon: Icon(Icons.home)),
          Tab(icon: Icon(Icons.local_grocery_store)),
          Tab(icon: Icon(Icons.person)),
        ]);
        screens.addAll(const [
          Icon(Icons.home),
          Store(),
          Account(),
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
