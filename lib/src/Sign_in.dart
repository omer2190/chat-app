import 'package:chat_app/src/Register.dart';
import 'package:chat_app/src/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../widgets/My_Butten.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _auth = FirebaseAuth.instance;
  late String email;
  late String pass;
  bool isvspass = true;
  bool loodeing = false;
  final kay = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final iskaybord = MediaQuery.of(context).viewInsets.bottom != 0;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Form(
        key: kay,
        child: ModalProgressHUD(
          inAsyncCall: loodeing,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Scrollbar(
              child: Column(
                mainAxisAlignment: iskaybord
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  !iskaybord
                      ? const FlutterLogo(
                          size: 160,
                        )
                      : const FlutterLogo(
                          size: 40,
                        ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                      child: TextFormField(
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
                            prefixIcon: const Icon(Icons.person),
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ))),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      child: TextFormField(
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
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {});
                                  isvspass = !isvspass;
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
                            border: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ))),
                  MyButten(
                      color: Colors.blue,
                      tetel: "Sign_In".tr,
                      onPrees: () {
                        final isvalue = kay.currentState!.validate();
                        if (isvalue) {
                          setState(() {
                            loodeing = true;
                          });
                          Sign_In();
                        }
                      }),
                  MyButten(
                      color: Colors.blueAccent,
                      tetel: "Register".tr,
                      onPrees: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const Register(),
                            ));
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

  void Sign_In() async {
    try {
      final user =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      if (user != null) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        // ignore: use_build_context_synchronously
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const Home(),
          ),
        );
        setState(() {
          loodeing = false;
        });
      }
    } catch (e) {
      //print("eeeeeeeeeeeeeeeee$e");
      setState(() {
        loodeing = false;
      });
    }
  }
}
