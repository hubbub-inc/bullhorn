import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blips/models/message_chat.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class ChatProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<MessageChat> _messages = [];
  BehaviorSubject<String> groupChatId = BehaviorSubject.seeded("empty");

  late StreamSubscription subscription;

  List<MessageChat> get messages => _messages.toSet().toList();

  ChatProvider() {
    _startQuery();
  }


  _startQuery() {


    var ref = _firestore.collection("chatMessages");

    // ref.doc(groupChatId.value).collection(groupChatId.value).snapshots()
    //                                       .listen(_updateMessages);

    // subscribe to query
    subscription = groupChatId.switchMap((chatId) {



      return ref.doc(chatId)
          .collection(chatId)
          .snapshots();})
          .listen(_updateMessages);

    }






  _updateMessages(QuerySnapshot querySnap) {
    if (querySnap.docs.isNotEmpty) {
      print("NOT EMPTY");

      List<MessageChat> message_list = [];
    querySnap.docs.forEach((i) {
      message_list.add(MessageChat(
          idFrom: 'user3',
          content: i['content'],
          timestamp: i['timestamp'].toDate()));
    });
      _messages = message_list;
    } else { print("EMPTY"); }

    notifyListeners();
  }

  updateChat(String chatId) {

        groupChatId.add(chatId);

  }






  Stream<QuerySnapshot> getChatStream(String groupChatId) {
    return _firestore.collection("chatMessages")
        .doc(groupChatId)
        .collection(groupChatId)
        .snapshots();
  }

  void sendMessage(String content, String groupChatId, String currentUserId) {
    DocumentReference documentReference = _firestore.collection("chatMessages")
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        timestamp: DateTime.now(),
        content: content
    );

    _firestore.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        messageChat.toJson(),
      );
    });
  }
}

