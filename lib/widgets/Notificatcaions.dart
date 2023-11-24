import 'dart:convert';

import 'package:http/http.dart ' as http;

class Notificatcaions {
  var serverToken =
      "AAAAWSDZfyE:APA91bHetUj8629_mIH1VbZRr6VqQve2an4Uygu7-vDeKL8LKOuPYJi5vyVhxOlw9-hW2P_KEPBr806rBz_ZgSeH90EoCCn408zojnBDf47hgPikk0J1VmqtPDYWJQvizsNbrtHHbCCA";

  sendNotfiy(String title, String bode, String token) async {
    print("hfghjjjjjjjjjjjjjjjjjjjjjjjj");
    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': bode.toString(),
            'title': title.toString()
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          },
          'to': "/topics/$token",
        },
      ),
    );
  }
}
