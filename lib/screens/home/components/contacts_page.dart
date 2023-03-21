import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starz/config.dart';
import 'package:starz/screens/phone_contacts/phoneContactspage.dart';
import 'package:whatsapp/whatsapp.dart';
import '../../../widgets/custom_card.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({
    Key? key,
  }) : super(key: key) {
    print(AppConfig.phoneNoID);
    snapshot = FirebaseFirestore.instance
        .collection("accounts")
        .doc(AppConfig.WABAID)
        .collection("discussion")
        .snapshots();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(PhoneContactsPage.id, arguments: {
              "fromChat": false,
              'to': null,
              'whatsAppApi': null
            });
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: snapshot,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('There are no current discussions'),
                  );
                }
                List<Widget> widgets = [];
                for (int i = 0; i < snapshot.data!.size; i++) {
                  String user = snapshot.data!.docs[i].data()['client'];
                  // users.remove(AppConfig.phoneNoID);

                  widgets.add(CustomCard(
                    roomId: snapshot.data!.docs[i].id,
                    toPhoneNumber: user,
                  ));
                }

                return SingleChildScrollView(
                  child: Column(
                    children: widgets,
                  ),
                );
              }
            }
            print("6");
            return CircularProgressIndicator();
          },
        ));
  }
}
