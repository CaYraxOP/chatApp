import 'dart:convert';
import 'dart:io';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:place_picker/entities/location_result.dart';
import 'package:place_picker/place_picker.dart';
import 'package:starz/api/whatsapp_api.dart';
import 'package:starz/models/message.dart';
import 'package:starz/services/location.dart';
import 'package:starz/widgets/reply_message_card_reply.dart';
import 'package:swipe_to/swipe_to.dart';
import '../../widgets/own_message_card.dart';
import '../../widgets/reply_card.dart';
import '../../config.dart';



class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  OtpScreen({required this.phoneNumber});

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  String _otp = '';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // make network request to verify OTP
      // if OTP is correct, log the user in
      // otherwise, show an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OTP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter the OTP sent to ${widget.phoneNumber}'),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'OTP'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  // add more validation here if needed
                  return null;
                  },
            onChanged: (value) {
              setState(() {
                _otp = value;
              });
            },
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitForm,
            child: Text('Submit'),
          ),
        ],
      ),
    ),
  ),
);
  }
}
