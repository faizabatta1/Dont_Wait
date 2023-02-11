import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import "package:http/http.dart" as http;

class CloudMessaging{
  static Future sendPushMessage(String body, String title, String token,
      {String? userId}) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAAglOh_88:APA91bEyoZq_3gxDAIJhRbhz6t7tRHI1DO4_Y4r7E91y68DgSC6RzTZod9aH16eSX8R28djqIqQfkM-CfbYoXFY00Q8wJqcKpzKrIemWwpf3s3EsJCXKgWGuRaZIzNvlRZ57AmZ24TXi',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
            },
            "to": token,
            'data':{
              'userId':'$userId'
            }
          },
        ),
      );
      print('done');
    } catch (e) {
      print("error push notification");
    }
  }


  static Future<String?> getToken() async {
    String? mtoken = "";
    await FirebaseMessaging.instance.getToken().then((token) {
      mtoken = token;
    });

    return mtoken;
  }

}