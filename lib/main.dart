import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/register_screen.dart';

Widget _defaultHome = const RegisterScreen();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Starz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: const RegisterPage(),
      routes: <String, WidgetBuilder>{
        '/': (context) => _defaultHome,
        // '/register': (BuildContext context) => const RegisterPage(),
        // '/login': (BuildContext context) => const LoginPage(),
        // '/home': (BuildContext context) => const DashboardPage(),
        // '/products': (BuildContext context) => const ProductsPage(),
      },
    );
  }
}
