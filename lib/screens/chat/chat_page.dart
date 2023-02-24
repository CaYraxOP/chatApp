import 'dart:io';
import 'dart:typed_data';
import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/models/message.dart';

import '../../widgets/own_message_card.dart';
import '../../widgets/reply_card.dart';

import '../../config.dart';

class ChatPage extends StatefulWidget {
  ChatPage({
    Key? key,
  }) : super(key: key) {
    roomId = Get.arguments['roomId'];
    phoneNumber = Get.arguments['to'];
    whatsApp = WhatsAppApi();
    whatsApp.setup(
        accessToken: AppConfig.apiKey,
        fromNumberId: int.tryParse(AppConfig.phoneNoID));
  }

  late WhatsAppApi whatsApp;
  static const id = "/chatPage";
  late String phoneNumber;
  late String roomId;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool show = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool sendButton = false;

  @override
  void initState() {
    super.initState();
    // connect();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  // void connect() {
  //   socket = IO.io("http://127.0.0.1:5001", <String, dynamic>{
  //     "transports": ["websocket"],
  //     "autoconnect": false,
  //   });
  //   socket.connect();
  //   socket.emit("signin", widget.sourceChat.id);

  //   socket.onConnect((data) {
  //     //print("connected");
  //     socket.on('message', (msg) {
  //       //print(msg);
  //       setMessage("destination", msg["message"]);
  //       _scrollController.animateTo(_scrollController.position.maxScrollExtent,
  //           duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  //     });
  //   });
  //   ///print(socket.connected);
  // }

  void sendMessage(String message, String recipientPhoneNumber) {
    setMessage('source', message);
    // setMessage("source", message);
    // socket.emit("message", {
    //   "message": message,
    //   "sourceId": sorceId,
    //   "targetId": targetId,
    // });
  }

  void setMessage(String type, String message) {
    widget.whatsApp
        .messagesText(
            message: _controller.text, to: int.parse(widget.phoneNumber))
        .then((value) async {
      print(value);
      await FirebaseFirestore.instance
          .collection("accounts")
          .doc(AppConfig.WABAID)
          .collection("discussion")
          .doc(widget.phoneNumber)
          .collection("messages")
          .add({
        "from": AppConfig.phoneNoID,
        "id": value['messages'][0]['id'],
        "text": {"body": message},
        "type": "text",
        "timestamp": DateTime.now()
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.blueGrey,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: AppBar(
              elevation: 0,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.blueGrey,
                      child: SvgPicture.asset(
                        "assets/person.svg",
                        color: Colors.white,
                        height: 36,
                        width: 36,
                      ),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.all(6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "+" + widget.phoneNumber,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: WillPopScope(
                onWillPop: () {
                  if (show) {
                    setState(() {
                      show = false;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                  return Future.value(false);
                },
                child: Column(children: [
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 140,
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection("accounts")
                            .doc(AppConfig.WABAID)
                            .collection("discussion")
                            .doc(widget.phoneNumber)
                            .collection("messages")
                            .orderBy("timestamp")
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Message> messages = [];
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            if (snapshot.hasData && snapshot.data != null) {
                              for (int i = 0; i < snapshot.data!.size; i++) {
                                messages.add(Message.fromMap(
                                    snapshot.data!.docs[i].data()));
                              }
                            }
                          }

                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: messages.length + 1,
                            itemBuilder: (context, index) {
                              if (index == messages.length) {
                                return Container(
                                  height: 70,
                                );
                              }
                              if (messages[index].from == AppConfig.phoneNoID) {
                                return OwnMessageCard(
                                    message: messages[index],
                                    time: DateFormat("HH:mm").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            messages[index]
                                                .timestamp
                                                .millisecondsSinceEpoch)));
                              } else {
                                return ReplyCard(
                                    message: messages[index],
                                    time: DateFormat("HH:mm").format(
                                        DateTime.fromMillisecondsSinceEpoch(
                                            messages[index]
                                                .timestamp
                                                .millisecondsSinceEpoch)));
                              }
                            },
                          );
                        }),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 70,
                                    child: Card(
                                      margin: const EdgeInsets.only(
                                          left: 2, right: 2, bottom: 8),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      child: TextFormField(
                                        controller: _controller,
                                        focusNode: focusNode,
                                        textAlignVertical:
                                            TextAlignVertical.center,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                        onChanged: (val) {
                                          if (val.isNotEmpty) {
                                            setState(() {
                                              sendButton = true;
                                            });
                                          } else {
                                            setState(() {
                                              sendButton = false;
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Type a message",
                                            prefixIcon: IconButton(
                                                onPressed: () {
                                                  focusNode.unfocus();
                                                  focusNode.canRequestFocus =
                                                      false;
                                                  setState(() {
                                                    show = !show;
                                                  });
                                                },
                                                icon: const Icon(
                                                    Icons.emoji_emotions)),
                                            suffixIcon: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          context: context,
                                                          builder: (builder) {
                                                            return bottomSheet();
                                                          });
                                                    },
                                                    icon: const Icon(
                                                        Icons.attach_file)),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                        Icons.camera_alt))
                                              ],
                                            ),
                                            contentPadding:
                                                const EdgeInsets.all(5)),
                                      ),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    bottom: 8,
                                    right: 5,
                                    left: 2,
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff128c7e),
                                    radius: 20,
                                    child: IconButton(
                                        onPressed: () {
                                          if (sendButton) {
                                            _scrollController.animateTo(
                                                _scrollController
                                                    .position.maxScrollExtent,
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeOut);
                                            sendMessage(
                                              _controller.text,
                                              widget.phoneNumber,
                                            );

                                            _controller.clear();
                                            setState(() {
                                              sendButton = false;
                                            });
                                          }
                                        },
                                        icon: Icon(
                                          sendButton ? Icons.send : Icons.mic,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            show ? emojiSelect() : Container(),
                          ],
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomSheet() {
    return SizedBox(
      height: 270,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(
                      Icons.insert_drive_file, Colors.indigo, "Document",
                      onTap: () async {
                    FilePickerResult? res = await FilePicker.platform.pickFiles(
                        allowMultiple: false,
                        type: FileType.custom,
                        allowedExtensions: [
                          'pdf',
                          'doc',
                          'docx',
                          'xls',
                          "xlms"
                        ]);

                    if (res == null) {
                      return;
                    }

                    if (res.count > 0) {
                      print(res.names);
                      String filePath = res.files.first.path!;
                      File doc = File(filePath);
                      print(filePath);

                      // var payload = await http.MultipartFile.fromPath(
                      //     "file", filePath,
                      //     contentType: MediaType.parse(
                      //         "application/${res.files[0].extension}"));

                      var id = (await widget.whatsApp.uploadMedia(
                          mediaType: MediaType.parse(
                              "application/${res.files[0].extension}"),
                          mediaFile: doc,
                          mediaName: res.files[0].name))['id'];

                      var link = await widget.whatsApp.getMediaUrl(mediaId: id);
                      print(link);

                      var mesgRes = await widget.whatsApp.messagesMedia(
                          mediaId: id,
                          // {AUDIO, CONTACTS, DOCUMENT, IMAGE, INTERACTIVE, LOCATION, REACTION, STICKER, TEMPLATE, TEXT, VIDEO}.toLowerCase()
                          mediaType: "document",
                          to: widget.phoneNumber);
                      print(mesgRes);

                      var messageObject = {
                        "document": {
                          "filename": res.files[0].name,
                          "mime_type": "application/${res.files[0].extension}",
                          "sha256": link['sha256'],
                          "id": id
                        },
                        "type": "document",
                        "from": AppConfig.phoneNoID,
                        "id": "",
                        "timestamp": DateTime.now()
                      };

                      await FirebaseFirestore.instance
                          .collection("accounts")
                          .doc(AppConfig.WABAID)
                          .collection("discussion")
                          .doc(widget.phoneNumber)
                          .collection("messages")
                          .add(messageObject);
                    }
                  }),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.insert_photo, Colors.purple, "Gallery",
                      onTap: () async {
                    PickedFile? file = await ImagePicker.platform
                        .pickImage(source: ImageSource.gallery);

                    if (file == null) return;

                    File doc = File(file.path);

                    String ext = file.path.split('.').last;

                    var id = (await widget.whatsApp.uploadMedia(
                        mediaType: MediaType.parse(
                            "image/${ext == 'jpg' ? 'jpeg' : ext}"),
                        mediaFile: doc,
                        mediaName: file.path.split('/').last))['id'];

                    var mesgRes = await widget.whatsApp.messagesMedia(
                        mediaId: id,
                        // {AUDIO, CONTACTS, DOCUMENT, IMAGE, INTERACTIVE, LOCATION, REACTION, STICKER, TEMPLATE, TEXT, VIDEO}.toLowerCase()
                        mediaType: "image",
                        to: widget.phoneNumber);
                    print(mesgRes);

                    var link = await widget.whatsApp.getMediaUrl(mediaId: id);
                    print(link);

                    var messageObject = {
                      "image": {
                        "mime_type": "image/${ext == 'jpg' ? 'jpeg' : ext}",
                        "sha256": link['sha256'],
                        "id": id
                      },
                      "type": "image",
                      "from": AppConfig.phoneNoID,
                      "id": "",
                      "timestamp": DateTime.now()
                    };

                    await FirebaseFirestore.instance
                        .collection("accounts")
                        .doc(AppConfig.WABAID)
                        .collection("discussion")
                        .doc(widget.phoneNumber)
                        .collection("messages")
                        .add(messageObject);
                  }),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, Colors.orange, "Audio"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.location_pin, Colors.teal, "Location"),
                  const SizedBox(
                    width: 40,
                  ),
                  iconCreation(Icons.person, Colors.blue, "Contact"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, Color color, String text,
      {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color,
            child: Icon(
              icon,
              size: 29,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(text, style: const TextStyle(fontSize: 13, color: Colors.black)),
        ],
      ),
    );
  }

  Widget emojiSelect() {
    return SizedBox(
      height: 300,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) {
          print(emoji);
          setState(() {
            _controller.text += emoji.emoji;
          });
        },
        onBackspacePressed: () {
          // Backspace-Button tapped logic
          // Remove this line to also remove the button in the UI
        },
        config: Config(
          columns: 8,
          emojiSizeMax: 28 *
              (Platform.isIOS
                  ? 1.30
                  : 1.0), // Issue: https://github.com/flutter/flutter/issues/28894
          verticalSpacing: 0,
          horizontalSpacing: 0,
          initCategory: Category.RECENT,
          bgColor: Colors.white,
          indicatorColor: const Color(0xff128c7e),
          iconColor: Colors.grey,
          iconColorSelected: const Color(0xff128c7e),
          //progressIndicatorColor: const Color(0xff128c7e),
          backspaceColor: const Color(0xff128c7e),
          skinToneDialogBgColor: Colors.white,
          skinToneIndicatorColor: Colors.grey,
          enableSkinTones: true,
          showRecentsTab: true,
          recentsLimit: 28,
          //noRecentsText: "No Recents",
          //noRecentsStyle: const TextStyle(fontSize: 20, color: Colors.black26),
          tabIndicatorAnimDuration: kTabScrollDuration,
          categoryIcons: const CategoryIcons(),
          buttonMode: ButtonMode.CUPERTINO,
        ),
      ),
    );
  }
}
