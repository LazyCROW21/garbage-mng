import 'package:flutter/material.dart';
import 'package:garbage_mng/providers/cart_provider.dart';
import 'package:garbage_mng/providers/theme_provider.dart';
import 'package:garbage_mng/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Cart()), ChangeNotifierProvider(create: (_) => ThemeNotifier())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  loadSettings() {
    SharedPreferences.getInstance().then((prefs) {
      context.read<ThemeNotifier>().toggleMode(prefs.getBool('darkMode')!);
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      themeMode: context.watch<ThemeNotifier>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.lightGreen,
        dividerColor: Colors.green,
        colorScheme: const ColorScheme.light(primary: Colors.lightGreen),
      ),
      darkTheme: ThemeData(
          fontFamily: 'Poppins',
          dividerColor: Colors.lightGreen,
          backgroundColor: Colors.black,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(primary: Colors.green),
          iconTheme: const IconThemeData(color: Colors.white),
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.green, foregroundColor: Colors.white)),
      initialRoute: '/home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
