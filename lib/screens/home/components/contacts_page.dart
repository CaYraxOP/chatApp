import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starz/config.dart';
import '../../../widgets/custom_card.dart';

class ContactsPage extends StatelessWidget {
  ContactsPage({
    Key? key,
  }) : super(key: key) {
    print(AppConfig.phoneNoID.replaceAll("/", "").toString());
    snapshot = FirebaseFirestore.instance.collection("room").where("users",
        arrayContainsAny: [
          AppConfig.phoneNoID.replaceAll("/", "").toString()
        ]).snapshots();
  }

  late Stream<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog();
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
                  List<dynamic> users = snapshot.data!.docs[i].data()['users'];
                  users.remove(AppConfig.phoneNoID.replaceAll("/", ""));

                  widgets.add(CustomCard(
                    roomId: snapshot.data!.docs[i].id,
                    toPhoneNumber: users.first,
                  ));
                }

                return Column(
                  children: widgets,
                );
              }
            }
            print("6");
            return CircularProgressIndicator();
          },
        ));
  }

  openDialog() {
    Get.defaultDialog(
      radius: 0,
      content: Form(
        // key: _formkey,
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.phone,
              onChanged: (value) {
                // phone = value;
                // print(phone);
              },
              decoration: InputDecoration(
                  hintText: "+2547********",
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder()),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Fluttertoast.showToast(msg: "Phone Number required");
                    },
                    child: const Text("Send Message"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
