import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

showdialog1(BuildContext context, String roomMaster, String uoserEmail,
    String roomId, String pass) {
  //String? title;
  // String? suptitle;
  // String? hintText;
  // String? Save;
  // String? cancel;
  String? newName;
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("edit_lock_rome".tr),
        content: TextFormField(
          onChanged: (value) {
            newName = value.toString();
          },
          decoration: InputDecoration(
              hintText: pass == null || pass == "" ? "passwoud".tr : pass),
        ),
        actionsAlignment: MainAxisAlignment.start,
        elevation: 10,
        actions: [
          TextButton(
              onPressed: () {
                if (uoserEmail == roomMaster) {
                  if (newName == "" || newName == null) {
                    FirebaseFirestore.instance
                        .collection("chat rooms")
                        .doc(roomId)
                        .update({"lock": false, "pass": ""}).then(
                            (value) => null);
                  } else {
                    FirebaseFirestore.instance
                        .collection("chat rooms")
                        .doc(roomId)
                        .update({"lock": true, "pass": newName}).then(
                            (value) => null);
                  }
                }
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
