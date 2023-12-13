// ignore: file_names
// ignore_for_file: unused_import, file_names, duplicate_ignore

import 'package:chat_app/src/sign_in.dart';
import 'package:chat_app/src/chet_room.dart';
import 'package:chat_app/src/home.dart';
import 'package:chat_app/widgets/My_Butten.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late String email;
  late String name;
  late String pass2;
  late String pass = "";
  bool isvspass = true;
  bool loodeing = false;
  final kay = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final iskaybord = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: ModalProgressHUD(
        inAsyncCall: loodeing,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Form(
            key: kay,
            child: Column(
              mainAxisAlignment: !iskaybord
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!iskaybord)
                  const FlutterLogo(
                    size: 160,
                  ),
                const SizedBox(
                  height: 50,
                ),
                TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      email = value;
                    },
                    validator: (Value) {
                      if (Value!.length < 4) {
                        return "Enter_the_Email_correctlyy".tr;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Enter_Your_Email".tr,
                      prefixIcon: const Icon(Icons.email),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (Value) {
                      if (Value!.isEmpty) {
                        return "Input_Your_Name".tr;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Input_Your_Name".tr,
                      prefixIcon: const Icon(Icons.person),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      pass = value;
                    },
                    validator: (Value) {
                      if (Value!.length < 6) {
                        return "Enter_at_least_6_character".tr;
                      }
                      return null;
                    },
                    obscureText: isvspass,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Enter Your Password".tr,
                      prefixIcon: const Icon(Icons.visibility),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isvspass = !isvspass;
                            });
                          },
                          child: isvspass
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.blue,
                                )),
                    )),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    textAlign: TextAlign.center,
                    onChanged: (value) {
                      pass2 = value;
                    },
                    validator: (Value) {
                      if (Value!.length < 6) {
                        return "Enter_at_least_6_character".tr;
                      } else {
                        if (pass2 == pass) {
                          return null;
                        } else {
                          return "password_does_not_match".tr;
                        }
                      }
                    },
                    obscureText: isvspass,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: "Confer_Your_password".tr,
                      prefixIcon: const Icon(Icons.visibility),
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              isvspass = !isvspass;
                            });
                          },
                          child: isvspass
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.blue,
                                )
                              : const Icon(
                                  Icons.visibility_off,
                                  color: Colors.blue,
                                )),
                    )),
                MyButten(
                    color: Colors.blue,
                    tetel: "Register".tr,
                    onPrees: () {
                      final isvalue = kay.currentState!.validate();
                      if (isvalue) {
                        regster();
                      }
                      //print(isvalue);
                    }),
                MyButten(
                    color: Colors.black54,
                    tetel: "Sign_In".tr,
                    onPrees: () {
                      Navigator.pop(context);
                      // ignore: use_build_context_synchronously
                      Navigator.push<void>(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const SignIn(),
                        ),
                      );
                      // _auth.send
                    })
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Future<void> regster() async {
    try {
      setState(() {
        loodeing = true;
      });
      final newuser = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass)
          .then((value) async {
        await _auth.currentUser?.updateDisplayName(name);
        await _firestore
            .collection("USERS")
            .doc(email.toString())
            .set({}).then((value) {
          FirebaseMessaging.instance.subscribeToTopic("new");
          FirebaseMessaging.instance.subscribeToTopic("911");
          Navigator.pop(context);
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const Home(),
            ),
          );
        });
      });
    } catch (e) {
      setState(() {
        loodeing = false;
      });
      //print(e);
    }
  }
}
