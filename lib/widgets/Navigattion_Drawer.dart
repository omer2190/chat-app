import 'package:chat_app/widgets/showdialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigattionDrawer extends StatefulWidget {
  const NavigattionDrawer(
      {required this.Room_id, required this.Uoser_email, super.key});

  final String Room_id;
  final String Uoser_email;

  @override
  State<NavigattionDrawer> createState() =>
      _NavigattionDrawer(Room_id: Room_id, Uoser_email: Uoser_email);
}

class _NavigattionDrawer extends State<NavigattionDrawer> {
  _NavigattionDrawer({required this.Room_id, required this.Uoser_email});
  late String Room_name = "";
  final String Room_id;
  late String Uoser_email = "";
  late String Room_master = "";
  late String Room_pass = "";
  late bool Room_lock = true;

  final _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    getupdetinfo();
  }

  getupdetinfo() {
    try {
      _firestore.collection("chat rooms").doc(Room_id).get().then((event) {
        setState(() {
          Room_name = event["name"].toString();
          Room_master = event["room_master"].toString();
          Room_pass = event["pass"].toString();
          Room_lock = event["lock"];
        });
        // print(event["name"]);
        // print(event["room_master"]);
        // print(event["pass"]);
        // print(event["lock"]);
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> usersStream = FirebaseFirestore.instance
        .collection('chat rooms')
        .doc(Room_id)
        .collection("uosrs_in_room")
        .snapshots();
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 40, left: 10, right: 10, bottom: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      showdialog(context);
                                    },
                                    child: Text(
                                      Room_name,
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.blue[900]),
                                    ),
                                  ),
                                  // const SizedBox(
                                  //   height: 4,
                                  // ),
                                  Text(Room_id,
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue[300]))
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.copy)),
                            )
                          ],
                        ),
                        Card(
                          child: ListTile(
                            enabled: Uoser_email == Room_master.toString(),
                            title: Row(
                              children: [
                                const Icon(Icons.lock),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text("lock_room".tr),
                              ],
                            ),
                            trailing:
                                Room_lock ? Text("lock".tr) : Text("open".tr),
                            onTap: () {
                              showdialog1(context, Room_master, Uoser_email,
                                  Room_id, Room_pass);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          "members".tr,
                          style: const TextStyle(fontSize: 24),
                          softWrap: true,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: StreamBuilder(
                            stream: usersStream,
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Something went wrong'.tr);
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Text("Loading".tr));
                              }
                              return Column(
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> data =
                                      document.data()! as Map<String, dynamic>;
                                  return Card(
                                      child: ListTile(
                                    title: Text(
                                      data["name"].toString(),
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    // subtitle: Text(
                                    //     "ID : " + document.id.toString()),
                                    onTap: () {
                                      // print(data["name"]);
                                    },
                                  ));
                                }).toList(),
                              );
                            },
                          ))
                    ],
                  ),
                ]),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton.icon(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection("USERS")
                      .doc(Uoser_email)
                      .collection("rooms")
                      .doc(Room_id)
                      .delete()
                      .then((value) => FirebaseFirestore.instance
                          .collection("chat rooms")
                          .doc(Room_id)
                          .collection("uosrs_in_room")
                          .doc(Uoser_email)
                          .delete())
                      .then((value) {
                    FirebaseMessaging.instance
                        .unsubscribeFromTopic(Room_id.toString());
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(Icons.output),
                label: Text("Out_the_room".tr)),
          )
        ],
      ),
    );
  }

  void eiddNameRoom() {
    //print("fthjhtkfhjktf");
  }

  showdialog(BuildContext context) {
    var newName;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("edit_room_name".tr),
          content: TextFormField(
            onChanged: (value) {
              newName = value.toString();
            },
            decoration: InputDecoration(hintText: "naw_name".tr),
          ),
          actionsAlignment: MainAxisAlignment.start,
          elevation: 10,
          actions: [
            TextButton(
                onPressed: () {
                  final docRef = FirebaseFirestore.instance
                      .collection("chat rooms")
                      .doc(Room_id);
                  final updates = <String, String>{"name": newName.toString()};
                  docRef.update(updates).then((value) {
                    final updates = <String, dynamic>{
                      "name": newName.toString(),
                    };
                    FirebaseFirestore.instance
                        .collection("USERS")
                        .doc(Uoser_email)
                        .collection("rooms")
                        .doc(Room_id)
                        .update(updates)
                        .then((value) {
                      // print("DocumentSnapshot successfully updated!");
                      setState(() {
                        Room_name = newName.toString();
                        Navigator.of(context).pop();
                        Navigator.pop(this.context);
                        Navigator.pop(this.context);
                      });
                      //  (e) => print("Error updating document $e");
                    });
                    //(e) => print("Error updating document $e");
                  });
                },
                child: Text("Save".tr)),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("cancel".tr))
          ],
        );
      },
    );
  }
}
