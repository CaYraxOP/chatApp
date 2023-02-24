import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/config.dart';
import 'package:starz/models/message.dart';

class ReplyCard extends StatelessWidget {
  ReplyCard({Key? key, required this.message, required this.time})
      : super(key: key) {
    whatsAppApi = WhatsAppApi()
      ..setup(
          accessToken: AppConfig.apiKey,
          fromNumberId: int.parse(AppConfig.phoneNoID));
  }
  final Message message;
  final String time;
  late WhatsAppApi whatsAppApi;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          // color: Color(0xffdcf8c6),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 50,
                  top: 5,
                  bottom: 10,
                ),
                child: message.type == 'document'
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            message.value['filename'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "file",
                            style:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                          )
                          // IconButton(
                          //     icon: Icon(Icons.download_for_offline),
                          //     color: Colors.green,
                          //     onPressed: () {
                          //       WhatsAppApi()
                          //         ..setup(
                          //             accessToken: AppConfig.apiKey,
                          //             fromNumberId:
                          //                 int.parse(AppConfig.phoneNoID))
                          //         ..downloadPDF(message.value['id']);
                          //     })
                        ],
                      )
                    : message.type == "image"
                        ? FutureBuilder(
                            future: whatsAppApi.getMediaUrl(
                                mediaId: message.value['id']),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                  imageUrl: snapshot.data['url'],
                                  httpHeaders: const {
                                    "Authorization":
                                        "Bearer ${AppConfig.apiKey}"
                                  },
                                );
                              }

                              return CircularProgressIndicator();
                            })
                        : Text(
                            message.type == 'text'
                                ? message.value['body']
                                : 'not Supported',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
