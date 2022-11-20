import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:garbage_mng/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// email: garbagemng2022@gmail.com
// pwd: GarBage2022

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      name: 'garbage-mng',
      options: const FirebaseOptions(
          apiKey: "AIzaSyDa42UtGTXvc0Bu3GEzMozTHGSEEJ2Ps-Q",
          authDomain: "garbage-mng-724fb.firebaseapp.com",
          projectId: "garba ge-mng-724fb",
          storageBucket: "garbage-mng-724fb.appspot.com",
          messagingSenderId: "958739902969",
          appId: "1:958739902969:web:f0b9a4f03dfd7313754d28"));
  runApp(MultiProvider(providers: [ChangeNotifierProvider(create: (_) => Cart())], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.lightGreen,
        dividerColor: Colors.green,
      ),
      darkTheme: ThemeData(
          fontFamily: 'Poppins',
          dividerColor: Colors.lightGreen,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(),
          iconTheme: const IconThemeData(color: Colors.white),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.green, foregroundColor: Colors.white)),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
