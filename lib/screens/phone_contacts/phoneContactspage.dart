import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/controllers/conctacts_controller.dart';
import 'package:sizer/sizer.dart';

class PhoneContactsPage extends GetView<ConctactsController> {
  const PhoneContactsPage({super.key});
  static const id = "/phone_contacts";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My conctacts")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                  hintText: "Search...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder()),
              controller: controller.searchQuery,
              onChanged: (value) {
                controller.updateFilteredContacts();
              },
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                  itemBuilder: (context, index) {
                    Contact currentContact = controller.filteredContacts[index];
                    return Column(
                      children: [
                        InkWell(
                          onTap: () async {
                            await Get.defaultDialog(
                              radius: 10,
                              title: "Add contact?",
                              middleText:
                                  "Would you like to add the following number : ${currentContact.phones.first.number.removeAllWhitespace}",
                              confirm: ElevatedButton(
                                  onPressed: () async {
                                    int to = 0;
                                    if (currentContact
                                        .phones.first.number.removeAllWhitespace
                                        .startsWith("+")) {
                                      to = int.parse(currentContact.phones.first
                                          .number.removeAllWhitespace
                                          .substring(1));
                                    } else {
                                      to = int.parse(
                                          "91${currentContact.phones.first.number.removeAllWhitespace}");
                                    }

                                    await controller.whatsapp.messagesTemplate(
                                        templateName: "hello_world", to: to);

                                    Get.showSnackbar(const GetSnackBar(
                                      messageText: Text("Message Sent"),
                                    ));
                                  },
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Center(child: Text("Yes")),
                                  )),
                              cancel: OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const SizedBox(
                                    width: double.infinity,
                                    child: Center(child: Text("No")),
                                  )),
                            );
                          },
                          child: ListTile(
                            title: Text(
                                "${currentContact.name.first} ${currentContact.name.last}"),
                            subtitle: Text(currentContact
                                .phones.first.number.removeAllWhitespace),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: const Divider(
                            thickness: 1,
                          ),
                        )
                      ],
                    );
                  },
                  itemCount: controller.filteredContacts.length),
            ),
          ),
        ],
      ),
    );
  }
}
