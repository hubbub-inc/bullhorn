import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:blips/models/message_chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBubble extends StatefulWidget {
  List<MessageChat> messages;
  ChatBubble(this.messages);
  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  final Stream<QuerySnapshot> _usersStream =
  FirebaseFirestore.instance.collection('messages').snapshots();

  bool isFromMe = true;

  String? loggedInEmail = FirebaseAuth.instance.currentUser?.email;
  Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) {
    print("NO OF MESSAGES IN CHAT");
    print(widget.messages.length.toString());
    return Flexible(
      child: ListView(
        padding: EdgeInsets.all(10.0),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: widget.messages.map((MessageChat document) {
          // data = document.data() as Map<String, dynamic>;
          // String email = data?['sender']?? "anon";
          // String message = data?['text'];
          // isFromMe = loggedInEmail == email;
          return Row(
            // crossAxisAlignment: isFromMe
            //     ? CrossAxisAlignment.end
            //     : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                elevation: 5.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      bottomLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    )),
                margin: EdgeInsets.all(5.0),
                color: Colors.blueGrey,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        document.content,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      // Text(
                      //   email,
                      //   style: TextStyle(
                      //     color: Colors.lightGreenAccent,
                      //     fontSize: 10,
                      //   ),

                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}