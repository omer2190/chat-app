import 'dart:ffi';

import 'package:chat_app/src/Register.dart';
import 'package:chat_app/src/Sign_in.dart';
import 'package:flutter/material.dart';

import '../widgets/My_Butten.dart';

class WelcomeSecreen extends StatefulWidget {
  const WelcomeSecreen({Key? key}) : super(key: key);

  @override
  State<WelcomeSecreen> createState() => WelcomeSecreenState();
}

class WelcomeSecreenState extends State<WelcomeSecreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: const [
                  FlutterLogo(
                    size: 160,
                  ),
                  Text(
                    "Chet App",
                    style: TextStyle(fontSize: 40),
                  )
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              MyButten(
                tetel: "Sign in",
                color: Colors.blue[900]!,
                onPrees: () {
                  print("object");
                  Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const SignIn(),
                    ),
                  );
                },
              ),
              MyButten(
                  color: Colors.black,
                  tetel: "Register",
                  onPrees: () {
                    Navigator.push<void>(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => const Register(),
                      ),
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}
