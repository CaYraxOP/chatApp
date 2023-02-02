import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starz/screens/home/providers/phone_number_provider.dart';

import 'model/chat_model.dart';
import 'widgets/button_card.dart';
import 'widgets/contact_card.dart';

class SelectContact extends ConsumerStatefulWidget {
  const SelectContact({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends ConsumerState<SelectContact> {
  @override
  Widget build(BuildContext context) {
    final phoneNumbers = ref.watch(phoneNumbersProvider);
    List<ChatModel> contactList = [
      ChatModel(
        name: "John Doe",
        status: "God is merciful",
      ),
      ChatModel(
        name: "James Doe",
        status: "God is merciful",
      ),
      ChatModel(
        name: "Lucy Doe",
        status: "God is merciful",
      ),
      ChatModel(
        name: "Mary Doe",
        status: "God is merciful",
      ),
      ChatModel(
        name: "Henry Doe",
        status: "Flutter developer",
      ),
    ];
    return phoneNumbers.when(data: (data) {
      return data.when((success) {
        return Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Contact",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${success.data.length} Contacts",
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                  size: 26,
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView.builder(
              itemBuilder: ((context, index) {
                var details = success.data[index];

                return ContactCard(contact: details);
              }),
              itemCount: success.data.length),
        );
      }, (error) {
        return Scaffold(
          body: Center(
            child: Text(error.toString()),
          ),
        );
      });
    }, error: (error, s) {
      return Scaffold(
          body: Center(
        child: Text(error.toString()),
      ));
    }, loading: () {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    });
  }
}
