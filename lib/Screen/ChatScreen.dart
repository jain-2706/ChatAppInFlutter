import 'package:chatapp/Chat/NewMessageScreen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  var isloading = true;
  void gettingNotification() async {
    var ab = FirebaseMessaging.instance;
    await ab.requestPermission();

    final token = await ab.getToken();
    ab.subscribeToTopic("chatting");
    print("The Token is ${token}");
  }

  void initState() {
    super.initState();
    gettingNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: Text("Chat Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              // if (isloading) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (ctx) => Splashscreen()),
              //   );
              // }
              await FirebaseAuth.instance.signOut();
              setState(() {
                isloading = false;
              });
              // if (!isloading) {
              //   Navigator.push(
              //     context,
              //     MaterialPageRoute(builder: (ctx) => Authscreen()),
              //   );
              // }
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(child: Newmessagescreen()),
      // body: Displaymessages(),
    );
  }
}
