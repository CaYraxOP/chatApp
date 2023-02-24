import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:starz/controllers/conctacts_controller.dart';
import 'package:starz/firebase_options.dart';
import 'package:get/get.dart';
import 'package:starz/screens/auth/login/login_page.dart';
import 'package:starz/screens/chat/chat_page.dart';
import 'package:starz/screens/home/home_screen.dart';
import 'package:starz/screens/page_chooser/page_chooser.dart';
import 'package:starz/screens/phone_contacts/phoneContactspage.dart';
import 'screens/register/register_screen.dart';

Widget _defaultHome = const RegisterScreen();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, devicetype) => GetMaterialApp(
        initialRoute: HomeScreen.id,
        debugShowCheckedModeBanner: false,
        title: 'Starz App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        //home: const RegisterPage(),
        getPages: [
          GetPage(name: HomeScreen.id, page: () => HomeScreen()),
          GetPage(name: RegisterScreen.id, page: () => RegisterScreen()),
          GetPage(name: ChatPage.id, page: () => ChatPage()),
          GetPage(name: LoginPage.id, page: () => LoginPage()),
          GetPage(name: PageChooser.id, page: () => PageChooser()),
          GetPage(name: PhoneContactsPage.id, page: () => PhoneContactsPage())
        ],
        initialBinding: BindingsBuilder(() {
          Get.lazyPut(() => ConctactsController(), fenix: true);
        }),
      ),
    );
  }
}
