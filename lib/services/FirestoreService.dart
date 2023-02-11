import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/constants/MessageType.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:dont_wait/services/FirebaseDatabaseService.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FirestoreService{
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static final int MAX_WORK_MINUTES = 480;

  static Future addUser({required Map<String,dynamic> data}) async{
    await firestore.collection("users").add({
      'uid':data['uid'],
      'firstname':data['firstname'],
      'lastname':data['lastname'],
      'phone':data['phone'],
      'gender':data['gender'],
      'image_url':data['image_url'],
      'device_token':data['device_token']
    });
  }

  static Future addCentre({required Map<String,dynamic> data}) async{
    await firestore.collection("centres").add({
      'uid':data['uid'],
      'placename':data['placename'],
      'phone':data['phone'],
      'image_url':data['image_url'],
      'open_time':data['open_time'],
      'close_time':data['close_time'],
      'tests':data['tests'],
      'branches':data['branches'],
      'email':data['email']
    });
  }

  static Future pushMessage({
    required String publisher,
    required String subscriber,
    required String content,
    required String subscriber_name,
    required String publisher_name,
    required MessageType messageType
  }) async{
    Map<String,dynamic> messageFormat = {
      'publisher': publisher,
      'subscriber': subscriber,
      'publisher_name':publisher_name,
      'subscriber_name':subscriber_name,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      "content":content,
      'type': messageType == MessageType.TEXT ? 'text' : 'image'
    };

    await firestore.collection("messages").add(messageFormat);
  }

  // static Future<bool> addBooking({required Map<String,dynamic> data, required BuildContext context}) async{
  //   bool bookingExists = await checkIfBookingExists(data: data);
  //   bool done = false;
  //   if(!bookingExists){
  //     int stillAvailableTime = await checkTestTotalTime(testName: data['test'],date:data['date'],centreId: data['centreId']);
  //     if(stillAvailableTime <= MAX_WORK_MINUTES){
  //       bool testTimeInRange = await checkBookingTimeRange(data: data);
  //       if(testTimeInRange){
  //         await firestore.collection("bookings").add(data).whenComplete(() async{
  //           String? token = await CloudMessaging.getToken();
  //           await CloudMessaging.sendPushMessage("booking was added successfully", "centre", token!);
  //           done = true;
  //         }).catchError((onError){
  //           Utils.showSnackbar(context: context, message: "$onError");
  //         });
  //       }else{
  //         Utils.showSnackbar(context: context, message: "out of centre work hours");
  //       }
  //
  //     }else{
  //       Utils.showSnackbar(context: context, message: "centre is full");
  //     }
  //   }else{
  //     Utils.showSnackbar(context: context, message: "booking is already exists");
  //   }
  //
  //   return done;
  // }

  static Future updateBooking({required Map<String,dynamic> newData,required String uid}) async{
    await firestore.doc("bookings/$uid").update(newData);
  }

  static Future deleteBooking(String ref) async{
    await firestore.doc("bookings/$ref").delete();
  }

  static Future pushReport(Map<String,dynamic> data) async{
    await firestore.collection("reports").add(data);
  }

  static Future updateUser({required Map<String,dynamic> newDate,required String ref}) async{
    await firestore.doc("users/$ref").update(newDate);
  }

  static Future getPublisherName({required String publisher}) async {
    var user = (await firestore.collection("users").get()).docs.where((element) => element['uid'] == publisher);
    return "${user.first['firstname']} ${user.first['lastname']}";
  }
  static Future getSubscriberName({required String subscriber}) async {
    var user = (await firestore.collection("users").get()).docs.where((element) => element['uid'] == subscriber);
    return "${user.first['placename']}";
  }

  static Future checkIfBookingExists({required Map<String,dynamic> data}) async{
    var docs = (await firestore.collection("bookings").get()).docs;
    return docs.any((field){
      return field['centreId'] == data['centreId'] && field['patientId'] == data['patientId'] && field['date'] == data['date'] && field['test'] == data['test'];
    });
  }

  static Future checkBookingTimeRange({required Map<String,dynamic> data}) async{
    var centre = (await firestore.collection("centres").get()).docs.where((field) => field['uid'] == data['centreId']).first;
    var openHour = int.parse((centre['open_time'] as String).split("-").first);
    var closeHour = int.parse((centre['close_time'] as String).split("-").first);
    var patientHour = int.parse((data['time'] as String).split("-").first);

    if(openHour - patientHour <= 0 && closeHour - patientHour >= 0){
      return true;
    }
    return false;
  }

  static Future checkTestTotalTime({required String testName,required String centreId,required String date}) async{
    String time = await FirebaseDatabaseService.fetchTestTime(testName);
    List tests = (await firestore.collection("bookings").get()).docs.where((element){
      return element['centreId'] == centreId && element['test'] == testName && element['date'] == date;
    }).toList();

    return int.parse(time) * tests.length + int.parse(time);
  }

  static Future createChatRoomIfNotExists({required String publisher,required String subscriber}) async{
    try {
      await firestore.collection("rooms").doc("$publisher$subscriber").get().then((doc) async{
        if(!doc.exists){
          await firestore.collection("rooms").add({

          });
        }
      });
    } catch (e) {

    }
  }

  static Future addApi(Map<String,dynamic> data) async{
    await firestore.collection("api").add(data);
  }

}

