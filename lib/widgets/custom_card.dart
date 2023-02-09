import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../screens/chat/chat_page.dart';

class CustomCard extends StatelessWidget {
  CustomCard({Key? key, required this.toPhoneNumber, required this.roomId})
      : super(key: key);

  String toPhoneNumber;
  String roomId;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.toNamed(ChatPage.id,
                arguments: {"to": toPhoneNumber, "roomId": roomId});
          },
          child: ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blueGrey,
              child: SvgPicture.asset("assets/person.svg",
                  color: Colors.white, height: 37, width: 37),
            ),
            title: Text(
              toPhoneNumber,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.done_all, color: Colors.grey, size: 12),
                const SizedBox(width: 5),
                Text("chat.currentMessage!",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]))
              ],
            ),
            trailing: Text("chat.time!"),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 20, left: 80),
          child: Divider(
            thickness: 1,
          ),
        )
      ],
    );
  }
}
