import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Newmessagescreen extends StatefulWidget {
  const Newmessagescreen({super.key});
  @override
  State<Newmessagescreen> createState() {
    return _Newmessagescreenstate();
  }
}

class _Newmessagescreenstate extends State<Newmessagescreen> {
  var textController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
  }

  void storedMessage() async {
    print(FirebaseAuth.instance.currentUser!.email);
    if (textController.text.isEmpty) {
      print("Dikkat");
      return;
    }

    try {
      final information = await FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      print("chal to rha hai");
      print("The information email is ${information.data()!["email"]}");

      try {
        await FirebaseFirestore.instance.collection("chat").add(({
          "message": textController.text,
          "time": Timestamp.now(),
          "email": information.data()!["email"],
          "username": information.data()!["username"],
        }));
        if (mounted) {
          FocusScope.of(context).unfocus();
        }
        textController.clear();
      } catch (e) {
        print("The error iisiii $e");
      }
    } catch (e) {
      print("Error because is $e");
    }
  }

  Map<String, dynamic> li = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: EdgeInsetsGeometry.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("chat")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, asyncSnapshot) {
                  if (asyncSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return CircularProgressIndicator(strokeWidth: 1);
                  }
                  if (asyncSnapshot.hasData) {
                    final dat = asyncSnapshot.data;
                    return Container(
                      margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 23,
                      ),

                      child: ListView.builder(
                        reverse: true,
                        itemCount: dat!.docs.length,
                        itemBuilder: (ctx, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment:
                                    FirebaseAuth.instance.currentUser!.email ==
                                        dat.docs[index].data()["email"]
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Column(
                                  children: [
                                    if (index < dat.docs.length - 1) ...[
                                      if (dat.docs[index + 1]
                                              .data()["username"] !=
                                          dat.docs[index]
                                              .data()["username"]) ...[
                                        Text(
                                          dat.docs[index].data()["username"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ] else
                                      Text(
                                        dat.docs[index].data()["username"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Card(
                                      color: Colors.yellowAccent,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          dat.docs[index].data()["message"],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Text(dat.docs[index].data()["time"].toString()),
                              // Text(dat.docs[index].data()["email"]),
                            ],
                          );
                        },
                      ),
                    );
                  }

                  return Center(child: Text("No Message Found"));
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Message",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.elliptical(8, 8),
                          ),
                        ),
                      ),
                      autocorrect: true,
                      controller: textController,
                      enableSuggestions: true,
                    ),
                  ),
                  SizedBox(width: 5),
                  IconButton(
                    onPressed: () {
                      storedMessage();
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
