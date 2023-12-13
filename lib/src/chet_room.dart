import 'package:chat_app/src/MyColors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/navigattion_drawer.dart';
import '../widgets/notificatcaions.dart';
import 'dart:io' as prefix;

class ChatRoom extends StatefulWidget {
  ChatRoom({required this.Room_id, required this.Room_name, super.key});
  String Room_id;
  String Room_name;

  @override
  State<ChatRoom> createState() => _ChatRoomState(Room_id: Room_id);
}

class _ChatRoomState extends State<ChatRoom> {
  _ChatRoomState({required this.Room_id});
  String Room_id;
  String? Room_name;
  late String? Room_master = "";
  late String? Room_pass = "";
  late bool? Room_lock = true;
  String? mass;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User _user;
  final massControlr = TextEditingController();
  late String? uir = "";

  @override
  void initState() {
    getuser();
    super.initState();
    getupdetinfo();
  }

  void getuser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _user = user;
      }
    } catch (e) {}
  }

  void getupdetinfo() {
    try {
      _firestore.collection("chat rooms").doc(Room_id).get().then((event) {
        setState(() {
          Room_name = event["name"];
          _firestore
              .collection("USERS")
              .doc(_user.email)
              .collection("rooms")
              .doc(Room_id)
              .set({"name": event["name"]});
        });
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // getupdetinfo();
    return Scaffold(
      drawer: NavigattionDrawer(
        Room_id: Room_id,
        Uoser_email: _user.email.toString(),
      ),
      appBar: AppBar(
        backgroundColor: ccolors().getCard(),
        title: Text(Room_name.toString()),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("chat rooms")
                  .doc(Room_id)
                  .collection(Room_id)
                  .orderBy("time")
                  .snapshots(),
              builder: (context, snapshot) {
                List<massgeLine> massWd = [];
                if (!snapshot.hasData) {
                  // add her
                  return Center(child: Text("Loading".tr));
                }
                final messages = snapshot.data!.docs.reversed;
                try {
                  for (var mess in messages) {
                    String? massText;
                    String? ImageUri;
                    String? massName;
                    String? carentUser;
                    try {
                      massText = mess.get("text").toString();
                      massName = mess.get("name").toString();
                      ImageUri = mess.get("imageUir");
                    } catch (e) {}

                    //massName = mess.get("name").toString();
                    final massId = mess.get("id").toString();
                    carentUser = _user.uid;

                    final maassWd = massgeLine(
                      name_id: massName.toString(),
                      massge: massText.toString(),
                      isMe: carentUser == massId,
                      user_name: massName.toString(),
                      ImageUir: ImageUri,
                    );
                    massWd.add(maassWd);
                  }
                } catch (e) {}

                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    children: massWd,
                  ),
                );
              }),
          Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: ccolors().getCard(),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: ccolors().getSpeshel(),
                  width: 2,
                  style: BorderStyle.values[1],
                )),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => pickImag(), icon: const Icon(Icons.image)),
                Expanded(
                    child: Container(
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: ccolors().getBodyBrone(),
                  ),
                  child: TextField(
                    controller: massControlr,
                    textInputAction: TextInputAction.newline,
                    //keyboardType: TextInputType.text,
                    minLines: 1,
                    maxLines: 15,
                    onChanged: (value) {
                      mass = value;
                    },
                    decoration: InputDecoration(
                        // suffixIcon: GestureDetector(
                        //     onDoubleTap: () => pickImag(),
                        //     child: const Icon(Icons.image)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        hintText: "write_you_message".tr,
                        border: InputBorder.none),
                  ),
                )),
                IconButton(
                  color: ccolors().getSpeshel(),
                  onPressed: () {
                    if (massControlr.text != "" &&
                        massControlr.text != " " &&
                        massControlr.text != null) {
                      SendMass(null);
                      massControlr.clear();
                      mass == null;
                    }
                  },
                  icon: const Icon(Icons.send_rounded),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }

  SendMass(String? uriimeg) {
    _firestore.collection("chat rooms").doc(Room_id).collection(Room_id).add({
      "text": massControlr.text.toString(),
      //"uir": uir.toString(),
      "name": _user.displayName,
      "id": _user.uid,
      "imageUir": uriimeg,
      "time": FieldValue.serverTimestamp()
    }).then((value) => startNavegeitn());
  }

  startNavegeitn() async {
    Notificatcaions().sendNotfiy(
        Room_name.toString(), _user.displayName.toString(), Room_id.toString());
  }

  pickImag() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final ref =
        FirebaseStorage.instance.ref().child("File/$Room_id/${image!.name}");
    // ref.putFile(pic);
    await ref.putFile(prefix.File(image.path)).then(
      (p0) async {
        //print(p0);
        //print(await ref.getDownloadURL());
        uir = await ref.getDownloadURL();
        SendMass(uir);
      },
    );
  }
}

class massgeLine extends StatelessWidget {
  const massgeLine(
      {this.name_id,
      this.massge,
      this.user_name,
      required this.isMe,
      super.key,
      this.ImageUir});

  final String? name_id;
  final String? massge;
  final String? ImageUir;
  final String? user_name;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          isMe
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // const CircleAvatar(
                    //   radius: 18,
                    //   child: Icon(Icons.person),
                    // ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Material(
                              color: ccolors().getSpeshel(),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: ImageUir == null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: massge!.length > 10
                                                ? Text(massge.toString(),
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.end)
                                                : Text(
                                                    "$massge",
                                                    style: const TextStyle(
                                                        color: Colors.white),
                                                    textAlign: TextAlign.end,
                                                  ),
                                          )
                                        : null,
                                  ),
                                  Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 25),
                                      child: const Text("data"))
                                ],
                              )),
                          Container(
                            color: Colors.black12,
                            child: ImageUir == null
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: ImageUir == null
                                        ? null
                                        : Image.network(
                                            ImageUir!,
                                            width: 100,
                                            height: 170,
                                          ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const CircleAvatar(
                      radius: 18,
                      child: Icon(Icons.person),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(user_name.toString()),
                          ),
                          Material(
                              color: ccolors().getCard(),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              child: ImageUir == null
                                  ? Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: massge!.length > 10
                                          ? Text(
                                              massge.toString(),
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            )
                                          : Text(
                                              "      $massge",
                                              style: const TextStyle(
                                                  color: Colors.black),
                                            ),
                                    )
                                  : null),
                          Container(
                            color: Colors.black12,
                            child: ImageUir == null
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.all(0),
                                    child: ImageUir == null
                                        ? null
                                        : Image.network(
                                            ImageUir!,
                                            width: 100,
                                            height: 170,
                                          ),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}
