import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:starz/screens/home/components/individual_chat_page.dart';

import '../model/chat_model.dart';
import '../select_contact.dart';
import '../widgets/custom_card.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final phoneEditingController = TextEditingController();
  final _formkey = GlobalKey();
  String? phone;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openDialog();

          // Navigator.push(context, MaterialPageRoute(builder: (context) {
          //   return const SelectContact();
          // }));
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return CustomCard();
        },
        itemCount: 4,
      ),
    );
  }

  openDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Form(
              key: _formkey,
              child: Column(
                children: [
                  TextFormField(
                    controller: phoneEditingController,
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      phone = value;
                      print(phone);
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
                            if (phone != null) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return IndividualPage(
                                  phoneNumber: phone!,
                                );
                              }));

                              phoneEditingController.clear();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Phone Number required");
                            }
                          },
                          child: const Text("Send Message"))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
