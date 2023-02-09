// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String from;
  String id;
  Timestamp timestamp;
  String type;
  String text;
  Message({
    required this.from,
    required this.id,
    required this.timestamp,
    required this.type,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'from': from,
      'id': id,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'type': type,
      'text': {"body": text},
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    print(map['timestamp'].runtimeType);
    return Message(
      from: map['from'] as String,
      id: map['id'] as String,
      timestamp: map['timestamp'],
      type: map['type'] as String,
      text: (map['text'] == null
          ? "message type not supported"
          : map['text']['body']) as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(from: $from, id: $id, timestamp: $timestamp, type: $type, text: $text)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.from == from &&
        other.id == id &&
        other.timestamp == timestamp &&
        other.type == type &&
        other.text == text;
  }

  @override
  int get hashCode {
    return from.hashCode ^
        id.hashCode ^
        timestamp.hashCode ^
        type.hashCode ^
        text.hashCode;
  }
}
