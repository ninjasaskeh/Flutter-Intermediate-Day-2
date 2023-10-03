import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/pages/sign_in_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constant.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;
const collectionPath = 'messages';

class ChatPage extends StatefulWidget {
  static const String routeName = "/chat_name";
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _auth = FirebaseAuth.instance;
  TextEditingController messageTextController = TextEditingController();
  late DateTime now;
  late String messageText;
  late String formattedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.forum),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, SignInPage.routeName, (route) => false);
            },
          ),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const MessageStream(),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: TextField(
                  controller: messageTextController,
                  onChanged: (newValue) {
                    messageText = newValue;
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: kMessageTextFieldDecoration,
                )),
                TextButton(
                  onPressed: () {
                    setState(() {
                      now = DateTime.now();
                      formattedDate = DateFormat('kk:mm:ss').format(now);
                    });
                    messageTextController.clear();
                    _firestore.collection(collectionPath)
                    .add({
                      'text': messageText.trim(),
                      'sender': loggedInUser.email!.trim(),
                      'time': formattedDate.trim()
                    });
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser!;
      loggedInUser = user;
      print(loggedInUser.email);
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {}
}

class MessageStream extends StatelessWidget {
  const MessageStream({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection(collectionPath)
          .orderBy('time', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlue,
            ),
          );
        }

        final messages = snapshot.data!.docs;
        return Expanded(
            child: ListView(
          reverse: true,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          children: messages.map((message) => Text(message['text'])).toList(),
        ));
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
 final String sender;
 final String text;
 final bool isMe;
 const MessageBubble(
     {Key? key, required this.sender, required this.text, required this.isMe})
     : super(key: key);


 @override
 Widget build(BuildContext context) {
   return Padding(
     padding: const EdgeInsets.all(8),
     child: Column(
       crossAxisAlignment:
           isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
       children: [
         Text(
           sender,
           style: const TextStyle(color: Colors.black54, fontSize: 12.0),
         ),
         const SizedBox(
           height: 5,
         ),
         Material(
           borderRadius: BorderRadius.only(
               topLeft: isMe ? const Radius.circular(30) : const Radius.circular(0),
               topRight: isMe ? const Radius.circular(0) : const Radius.circular(30),
               bottomLeft: const Radius.circular(30),
               bottomRight: const Radius.circular(30)),
           elevation: 5.0,
           color: isMe ? Colors.lightBlue : Colors.white,
           child: Padding(
             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
             child: Text(
               text,
               style: TextStyle(
                   color: isMe ? Colors.white : Colors.black54,
                   fontSize: 15.0),
             ),
           ),
         )
       ],
     ),
   );
 }
}




