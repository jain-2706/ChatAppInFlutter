import 'dart:io';

import 'package:chatapp/Screen/ChatScreen.dart';
import 'package:chatapp/Widgets/imageTaking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class Authscreen extends StatefulWidget {
  const Authscreen({super.key});
  @override
  State<Authscreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<Authscreen> {
  final _globlkey = GlobalKey<FormState>();
  var entererdEmail = '';
  var enteredPassword = '';
  var username = '';
  var _islogin = true;
  var isauthenticating = false;
  var instance = FirebaseAuth.instance;

  File? img;

  void setImg(File ig) {
    setState(() {
      img = ig;
    });
  }

  void _saveKey() async {
    if (_globlkey.currentState!.validate()) {
      if (!_islogin) {
        if (img == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Fill the image field first"),
              duration: Duration(seconds: 1),
            ),
          );
          return;
        }
      }
      _globlkey.currentState!.save();
      if (_islogin) {
        try {
          final ans = await instance.signInWithEmailAndPassword(
            email: entererdEmail,
            password: enteredPassword,
          );
          final emailAuth = instance.currentUser!.email;
          print("The emailauth is ${emailAuth}");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => Chatscreen()),
          );
        } on FirebaseAuthException catch (e) {
          print("The coming is ${e.code}");

          if (!mounted) return;
          // if (e.code == "user-not-found") {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Email Not exist")));
          // }
        }
      } else {
        try {
          setState(() {
            isauthenticating = true;
          });
          final ans = await instance.createUserWithEmailAndPassword(
            email: entererdEmail,
            password: enteredPassword,
          );
          setState(() {
            isauthenticating = false;
          });
          // final storageref = FirebaseStorage.instance
          //     .ref()
          //     .child("User-Images")
          //     .child("${ans.user!.uid}.jpg");

          // final task = await storageref.putString("tHE");
          // print(storageref.getDownloadURL());
          final ab = instance.currentUser!;
          print(
            "The email of current user is ${instance.currentUser!.email}",
          ); //To get the current user email

          print(
            "The ans.uid is ${ans.user!.uid} and The ab.uid is ${ab.uid}",
          ); //Both are same

          FirebaseFirestore.instance.collection("Users").doc(ab.uid).set({
            "email": entererdEmail,
            "username": username,
          });

          print("Successfully Added");
        } on FirebaseAuthException catch (e) {
          setState(() {
            isauthenticating = false;
          });
          if (e.code == "email-already-in-use") {}

          if (!mounted) return;
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Not properly Added")));
          print("The error is $e");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/images/chat.png", width: 200, height: 180),
              Padding(
                padding: EdgeInsetsGeometry.all(16.0),
                child: Card(
                  child: Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: 30,
                        right: 30,
                        top: 15,
                        bottom: 15,
                      ),
                      child: SingleChildScrollView(
                        child: isauthenticating
                            ? CircularProgressIndicator()
                            : Form(
                                key: _globlkey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (!_islogin) ...[
                                      Imagetaking(setImg: setImg),
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null ||
                                              value.isEmpty ||
                                              value.trim().length < 4) {
                                            return "Pls Fill all required Fields";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          labelText: "Username",
                                        ),
                                        onSaved: (newValue) {
                                          setState(() {
                                            username = newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                    TextFormField(
                                      decoration: InputDecoration(
                                        label: Text("Email Address"),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty ||
                                            !value.contains("@")) {
                                          return "Pls enter the valid Email Address";
                                        }
                                        return null;
                                      },
                                      autocorrect: true,
                                      keyboardAppearance: Brightness.dark,
                                      onSaved: (newValue) {
                                        entererdEmail = newValue!;
                                        print(entererdEmail);
                                      },
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        labelText: "Password",
                                      ),
                                      obscureText: true,
                                      validator: (value) {
                                        if (value == null || value.length < 6) {
                                          return "Pls enter Password of minimum 6 characters";
                                        }
                                        return null;
                                      },
                                      onSaved: (newValue) {
                                        enteredPassword = newValue!;
                                        print(enteredPassword);
                                      },
                                    ),
                                    SizedBox(height: 15),
                                    ElevatedButton(
                                      onPressed: () {
                                        _saveKey();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                          255,
                                          76,
                                          150,
                                          211,
                                        ),
                                      ),
                                      child: Text(
                                        _islogin ? "Login" : "SignUp",
                                      ),
                                    ),
                                    SizedBox(height: 1),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _islogin = !_islogin;
                                        });
                                      },
                                      child: Text(
                                        _islogin
                                            ? "Create Account"
                                            : "I already have an account",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
