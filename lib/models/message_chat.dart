import 'package:cloud_firestore/cloud_firestore.dart';

class MessageChat {
  String idFrom;
  DateTime timestamp;
  String content;

  MessageChat({
    required this.idFrom,
    required this.timestamp,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      "idFrom": this.idFrom,
      "timestamp": this.timestamp,
      "content": this.content
    };
  }

  factory MessageChat.fromDocument(DocumentSnapshot doc) {
    String idFrom = doc.get("idFrom");
    DateTime timestamp = doc.get("timestamp");
    String content = doc.get("content");
    return MessageChat(idFrom: idFrom, timestamp: timestamp, content: content);
  }

}
