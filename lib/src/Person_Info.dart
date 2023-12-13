import 'package:chat_app/src/Sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ThemeService.dart';

class PersonInfo extends StatefulWidget {
  const PersonInfo(
      {required this.user_name, required this.user_email, super.key});
  final String user_name;
  final String user_email;

  @override
  State<PersonInfo> createState() => _PersonInfo(
        user_name: user_name,
        user_email: user_email,
      );
}

class _PersonInfo extends State<PersonInfo> {
  _PersonInfo({required this.user_name, required this.user_email, Key? key});
  final String user_name;
  final String user_email;

  bool witch_val = false;
  late bool darck = false;
  late String log_bet = "en";
  @override
  void initState() {
    super.initState();
    ceckv();
  }

  @override
  Widget build(BuildContext context) {
    String value;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 30, top: 10),
            child: Column(children: [
              const CircleAvatar(
                radius: 50,
              ),
              Container(
                padding: const EdgeInsets.all(7),
                child: Text(
                  user_name,
                  style: const TextStyle(fontSize: 24),
                ),
              )
            ]),
          ),
          Card(
            margin: const EdgeInsets.only(top: 30, right: 15, left: 15),
            child: SwitchListTile(
              title: Text("Darck_Mood".tr),
              value: witch_val,
              onChanged: (bool v) {
                // witch_val = v;

                setState(() {
                  witch_val = v;
                  ThemeService().changeTheme(v);
                  ThemeService().saveThemeData(v);
                  //print(witch_val.toString());
                });
              },
            ),
          ),
          Card(
            margin: const EdgeInsets.only(top: 25, right: 15, left: 15),
            child: Column(children: [
              Row(
                children: [
                  Text("my_account".tr),
                ],
              ),
              ListTile(
                title: Row(
                  children: [Text("Email".tr), Text(user_email)],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note),
                ),
              ),
              ListTile(
                title: Row(
                  children: [Text("phone_Namber".tr), const Text("data")],
                ),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_note),
                ),
              ),
              ListTile(
                  title: Row(
                    children: [Text("Password".tr), const Text("********")],
                  ),
                  trailing: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.looks)))
            ]),
          ),
          Card(
            margin: const EdgeInsets.only(top: 25, right: 15, left: 15),
            child: Column(children: [
              Row(
                children: [
                  Text("stening".tr),
                ],
              ),
              ListTile(
                  title: Row(
                    children: [
                      Text("Language".tr),
                    ],
                  ),
                  trailing: DropdownButton(
                    value: log_bet,
                    items: <String>[
                      "en",
                      "ar",
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      value = newValue!;
                      //log_bet = value..prefLang.value;
                      Get.updateLocale(Locale(newValue.toLowerCase()));

                      //print("hhhhhh  :  " + newValue.toString());
                      setState(() {
                        log_bet = newValue.toString();
                      });
                      SharedPreferences prefService =
                          await SharedPreferences.getInstance();
                      prefService.setString("locale", newValue);
                    },
                  )),
              ListTile(
                title: Text("conect_us".tr),
                trailing: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.call),
                ),
              ),
              ListTile(
                title: Text("Sign_out".tr),
                trailing: IconButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) => const SignIn()));
                  },
                  icon: const Icon(Icons.output),
                ),
              )
            ]),
          ),
        ],
      ),
    ));
  }

  Future<void> ceckv() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String bb = share.getString("isDarkTheme").toString();
    if (bb == "true") {
      setState(() {
        witch_val = true;
      });
    } else {
      witch_val = false;
    }
  }
}
