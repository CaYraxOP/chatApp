import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:starz/screens/auth/login/login_page.dart';
import 'package:starz/screens/privacy&policy/privacy_and_policy.dart';

import 'components/contacts_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  static const id = "/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Starz'),
        leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FacebookAuth.i.logOut();
              Get.offNamed(LoginPage.id);
            }),
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed(PrivacyAndPolicyPage.id);
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: ContactsPage(),
    );
  }
}
