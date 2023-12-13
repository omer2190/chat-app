import 'package:chat_app/src/MyColors.dart';
import 'package:chat_app/src/chet_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'person_Info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? mass;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _user;
  bool appbarinpot = false;

  final massControlr = TextEditingController();
  @override
  void initState() {
    super.initState();

    getuser();
    getLog();
    FirebaseMessaging.instance.getToken().then((value) async {
      _firestore
          .collection("USERS")
          .doc(_user.email)
          .set({"tokon": value.toString()});
    });
  }

  void getLog() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    String locl = share.getString("locale").toString();
    if (locl == null) {
      Get.updateLocale(const Locale("ar"));
    } else {
      await Get.updateLocale(Locale(locl.toString().toLowerCase()));
    }
  }

  void getuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('USERS')
        .doc(_user.email)
        .collection("rooms")
        .snapshots();
    return Scaffold(
        appBar: appbarinpot
            ? AppBar(
                title: const TextField(),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      appbarinpot = false;
                    });
                  },
                ),
              )
            : AppBar(
                backgroundColor: ccolors().getCard(),
                title: const Text("Chat App"),
                leading: Padding(
                  padding: const EdgeInsets.all(1),
                  child: IconButton(
                    color: ccolors().getSpeshel(),
                    icon: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => PersonInfo(
                            user_name: _user.displayName.toString(),
                            user_email: _user.email.toString(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  IconButton(
                      color: ccolors().getSpeshel(),
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: delegate(_user.email.toString(),
                                _user.displayName.toString()));
                      },
                      icon: const Icon(Icons.search))
                ],
              ),
        body: SafeArea(
          child: StreamBuilder(
            stream: usersStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong'.tr);
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text("Loading".tr));
              }
              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                      child: ListTile(
                    tileColor: ccolors().getBody(),
                    leading: const Icon(Icons.group),
                    title: Text(
                      data["name"].toString(),
                      style: const TextStyle(fontSize: 24),
                    ),
                    subtitle: Text("ID : ${document.id}"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => ChatRoom(
                            Room_id: document.id.toString(),
                            Room_name: data["name"].toString(),
                          ),
                        ),
                      );
                    },
                  ));
                }).toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          foregroundColor: ccolors().getCard(),
          backgroundColor: ccolors().getSpeshel(),
          child: const Icon(Icons.add),
          onPressed: () {
            _firestore.collection("chat rooms").add({
              "name": "New Room",
              "room_master": _user.email,
              "lock": true,
              "pass": null,
              "dataTime": FieldValue.serverTimestamp()
            }).then((value) {
              FirebaseFirestore.instance
                  .collection('USERS')
                  .doc(_user.email)
                  .collection("rooms")
                  .doc(value.id)
                  .set({"name": "New Room"});
              FirebaseFirestore.instance
                  .collection("chat rooms")
                  .doc(value.id)
                  .collection("uosrs_in_room")
                  .doc(_user.email)
                  .set({
                "name": _user.displayName.toString(),
                "date": FieldValue.serverTimestamp()
              });
              FirebaseMessaging.instance.subscribeToTopic(value.id.toString());
            });
          },
        ));
  }
}

class delegate extends SearchDelegate {
  delegate(this.email, this.name) {
    getroom();
  }
  String email;
  String name;
  final _firestore = FirebaseFirestore.instance;

  List<String> searcch = [];

  final kay = GlobalKey<FormState>();

  void getroom() async {
    final rooms = await _firestore.collection("chat rooms").get();
    for (var room in rooms.docs) {
      searcch.add(room.id);
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> match = [];
    for (var fruit in searcch) {
      if (query.length > 3) {
        if (fruit.toLowerCase().contains(query.toLowerCase())) {
          match.add(fruit);
        }
      }
    }
    return ListView.builder(
      itemCount: match.length,
      itemBuilder: (context, index) {
        var result = match[index];
        return ListTile(
          title: Text(result),
          onTap: () {
            final b = _firestore.collection("chat rooms").doc(result);
            b.get().then(
              (DocumentSnapshot doc) {
                final data = doc.data() as Map<String, dynamic>;
                if (data["lock"] == false || data["lock"] == null) {
                  // print(data["lock"].toString() + "kmlkm");
                  joinroom(result);
                } else {
                  showdialog(context, data["pass"], result);
                  //print(data["lock"]);
                }
              },
              onError: (e) => print("Error getting document: $e"),
            );
            close(context, null);
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> match = [];
    for (var fruit in searcch) {
      if (fruit.toLowerCase().contains(query.toLowerCase())) {
        match.add(fruit);
      }
    }
    return ListView.builder(
      itemCount: match.length,
      itemBuilder: (context, index) {
        var result = match[index];
        return const ListTile(
            // title: Text(result),
            );
      },
    );
  }

  showdialog(BuildContext context, var pass, String result) {
    var new_name;
    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: kay,
          child: AlertDialog(
            title: Column(
              children: [
                Text("entering_the_room".tr),
                Text(
                  "to_join_the_room_you_must_enter_the_password".tr,
                  style: const TextStyle(fontSize: 14),
                )
              ],
            ),
            content: TextFormField(
              onChanged: (value) {
                new_name = value.toString();
              },
              decoration: InputDecoration(hintText: "password".tr),
              validator: (Value) {
                if (Value!.length < 4) {
                  return "Enter_at_least_4_character".tr;
                } else {
                  if (Value != pass) {
                    return "password_is_not_true".tr;
                  }
                }
                // return null;
              },
            ),
            actionsAlignment: MainAxisAlignment.start,
            elevation: 10,
            actions: [
              TextButton(
                  onPressed: () {
                    final isvalue = kay.currentState!.validate();
                    if (isvalue) {
                      joinroom(result);
                    } else {}
                  },
                  child: Text("Save".tr)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("cancel".tr))
            ],
          ),
        );
      },
    );
  }

  joinroom(String result) {
    FirebaseFirestore.instance
        .collection("USERS")
        .doc(email)
        .collection("rooms")
        .doc(result)
        .set({}).then((value) {
      FirebaseFirestore.instance
          .collection("chat rooms")
          .doc(result)
          .collection("uosrs_in_room")
          .doc(email)
          .set({"name": name, "date": FieldValue.serverTimestamp()});
      FirebaseMessaging.instance.subscribeToTopic(result.toString());
    });
  }
}
