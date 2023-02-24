import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/config.dart';
import 'package:starz/models/message.dart';
import 'package:http/http.dart' as http;

class OwnMessageCard extends StatelessWidget {
  OwnMessageCard({Key? key, required this.message, required this.time})
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
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width - 45, minWidth: 110),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: const Color(0xffdcf8c6),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: message.type == 'document'
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
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
                                : 'Not supported',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
