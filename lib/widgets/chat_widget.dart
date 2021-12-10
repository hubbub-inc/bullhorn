import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blips/providers/chat_provider.dart';
import 'package:blips/models/message_chat.dart';
import 'package:blips/constants.dart';
import 'package:blips/widgets/chat_bubble.dart';



class ChatWidget extends StatefulWidget {
  String chatId;
  ChatProvider chatProvider;
  ChatWidget({required this.chatProvider, required this.chatId});
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  // CollectionReference messages =
  // FirebaseFirestore.instance.collection('messages');
  // late ChatProvider chatProvider;
  TextEditingController messageController = new TextEditingController();

  String? message = "";

  // Future<void> addMessage() {
  //   return messages
  //       .add({
  //     'sender': FirebaseAuth.instance.currentUser?.email?? "anon",
  //     'text': message?? "anon"
  //   })
  //       .then((value) => print("Message Added"))
  //       .catchError((error) => print("Failed to add user: $error"));
  // }

  @override
  Widget build(BuildContext context) {
    widget.chatProvider.updateChat(widget.chatId);
    Widget bubble = ChatBubble(widget.chatProvider.messages);
    return  SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            bubble,
            // StreamBuilder<QuerySnapshot>(
            //     stream: widget.chatProvider.getChatStream(widget.chatId),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return Text(
            //           'No Data...',
            //         );
            //       } else {
            //         List<MessageChat> messages = [];
            //
            //         snapshot.data?.docs.forEach((i) {
            //           messages.add(MessageChat(
            //               idFrom: 'user3',
            //               content: i['content'],
            //               timestamp: i['timestamp'].toDate()));
            //         });
            //
            //
            //         return ChatBubble(messages);
            //       }}),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {

                      if (messageController.text!="") {
                        widget.chatProvider.sendMessage(
                            messageController.text, widget.chatId, "user3");
                        messageController.clear();
                        // addMessage();
                      }
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}