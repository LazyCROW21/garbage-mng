import 'package:flutter/material.dart';
import 'package:garbage_mng/models/user_model.dart';
import 'package:garbage_mng/models/waste_item_model.dart';
import 'package:garbage_mng/ui/screens/add_waste_item.dart';
import 'package:garbage_mng/ui/screens/edit_org_details.dart';
import 'package:garbage_mng/ui/screens/home.dart';
import 'package:garbage_mng/ui/screens/login.dart';
import 'package:garbage_mng/ui/screens/signup.dart';
import 'package:garbage_mng/ui/screens/view_waste_item.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/viewWasteItem':
        WasteItemModel wasteItem = args as WasteItemModel;
        return MaterialPageRoute(builder: (_) => ViewWasteItemScreen(wasteItem: wasteItem));
      case '/addWasteItem':
        WasteItemModel? editItem = args as WasteItemModel?;
        return MaterialPageRoute(builder: (_) => AddWasteItemScreen(editItem: editItem));
      case '/editOrganisation':
        UserModel? org = args as UserModel?;
        return MaterialPageRoute(
            builder: (_) => EditOrganisationDetails(
                  editOrganisation: org,
                ));
      // case '/second':
      // // Validation of correct data type
      //   if (args is String) {
      //     return MaterialPageRoute(
      //       builder: (_) => SecondPage(
      //         data: args,
      //       ),
      //     );
      //   }
      //   // If args is not of the correct type, return an error page.
      //   // You can also throw an exception while in development.
      //   return _errorRoute();
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
