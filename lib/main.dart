import 'package:flutter/material.dart';
import 'package:garbage_mng/route.dart';
import 'package:firebase_core/firebase_core.dart';

// email: garbagemng2022@gmail.com
// pwd: GarBage2022

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDa42UtGTXvc0Bu3GEzMozTHGSEEJ2Ps-Q",
          authDomain: "garbage-mng-724fb.firebaseapp.com",
          projectId: "garbage-mng-724fb",
          storageBucket: "garbage-mng-724fb.appspot.com",
          messagingSenderId: "958739902969",
          appId: "1:958739902969:web:f0b9a4f03dfd7313754d28"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.lightGreen,
      ),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
