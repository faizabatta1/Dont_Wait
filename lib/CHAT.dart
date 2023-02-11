  import 'dart:math';

  import 'package:badges/badges.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:dont_wait/Auth.dart';
  import 'package:dont_wait/ChatScreen.dart';
  import 'package:dont_wait/constants/UserType.dart';
  import 'package:dont_wait/services/AuthChangeNotifier.dart';
  import 'package:dont_wait/services/Authentication.dart';
  import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
  import 'package:provider/provider.dart';

  import 'CHAT.dart';
  import 'Signup/ThemeHelper.dart';
  import 'home_screen.dart';

  class chat extends StatefulWidget {
    final String subscriber;
    const chat({super.key, required this.subscriber});

    @override
    _DataTableExample createState() => _DataTableExample();
  }

  class _DataTableExample extends State<chat> {


    @override
    void initState() {
      super.initState();

    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
            appBar: AppBar(

              backgroundColor: Colors.teal,
              title: const Text('Messages',style: TextStyle(fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic, fontSize: 25,fontFamily: 'ultra' ,color: Colors.white)),
              centerTitle: true,

            ),


            body: StreamBuilder(

              //TODO.txt: FIX UNIDIRECTIONAL MESSAGES
              stream: FirebaseFirestore.instance.collection("messages").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  // 3 levels of streams
                // level1: get All publisher contacts
                  if(snapshot.hasData && !snapshot.hasError){
                    UserType userHandler = Provider.of<AuthChangeNotifier>(context,listen: false).userType;
                    String uid = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
                    Set subCollection = Set();
                    List totalContacts;
                    List subscriberMessages;
                    String collection = "";

                    if(userHandler == UserType.NORMAL){
                      subscriberMessages = snapshot.data!.docs
                          .where((element) => element['publisher'] == uid).toList();

                      for(var message in subscriberMessages){
                        subCollection.add(message['subscriber']);
                      }

                     totalContacts = subCollection.toList();
                      collection = "centres";

                    }else{
                      subscriberMessages = snapshot.data!.docs
                          .where((element) => element['subscriber'] == uid).toList();

                      for(var message in subscriberMessages){
                        subCollection.add(message['publisher']);
                      }

                      totalContacts = subCollection.toList();
                      collection = "users";
                    }

                    return ListView.builder(
                      itemCount: totalContacts.length,
                      itemBuilder: (BuildContext context,int i){
                        return StreamBuilder(
                            stream: FirestoreService.firestore.collection("messages").snapshots(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData && !snapshot.hasError){
                                var messages;
                                var nameHolder;

                                if(userHandler == UserType.NORMAL){
                                  messages = snapshot.data!.docs
                                      .where((element) => element['subscriber'] == totalContacts[i] || element['publisher'] == totalContacts[i]).toList();

                                  nameHolder = 'subscriber_name';
                                }else{
                                  messages = snapshot.data!.docs
                                      .where((element) => element['publisher'] == totalContacts[i] || element['subscriber'] == totalContacts[i]).toList();

                                  nameHolder = "publisher_name";
                                }
                                messages.sort((a,b){
                                  return (a["timestamp"] as int) - (b['timestamp'] as int);
                                });

                                return Container(
                                  child: Column(
                                    children: [
                                      SizedBox(height: 30,),
                                      InkWell(

                                        onTap: (){
                                          if(userHandler == UserType.NORMAL){
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                              return ChatScreen(subscriber: totalContacts[i], publisher: uid, subscriber_name: messages.first['subscriber_name'],);
                                            }));
                                          }else{
                                            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                              return ChatScreen(subscriber: uid, publisher: totalContacts[i], subscriber_name: messages.first['publisher_name'],);
                                            }));
                                          }
                                        },

                                        child: Container(

                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 5)],
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(40),
                                              topRight: Radius.circular(40),
                                              bottomRight: Radius.circular(40),
                                              bottomLeft: Radius.circular(40),
                                            ),
                                          ),
                                          child: ListTile(

                                            shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 3, color: Colors.teal),
                                              borderRadius: BorderRadius.circular(20),
                                            ),

                                            title: Text("${messages.first[nameHolder]}",style: const TextStyle(fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                            leading: FutureBuilder(

                                              future: userHandler == UserType.NORMAL ?  getCentre(totalContacts[i]) : getUserData(totalContacts[i]),
                                              builder: (context,snapshot){
                                                if(snapshot.hasData && !snapshot.hasError){
                                                  Map? img = snapshot.data;
                                                  return CircleAvatar(
                                                    backgroundColor: Colors.teal,
                                                    backgroundImage: NetworkImage(img!['image']),
                                                  );
                                                }else{
                                                  return CircularProgressIndicator();
                                                }
                                              },
                                            ),
                                            trailing: Text("${DateFormat('yyyy-MM-dd  hh-ss').format(DateTime.fromMillisecondsSinceEpoch(messages.last['timestamp']))}",style: const TextStyle(fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic, fontSize: 10,fontFamily: 'ultra' ,color: Colors.black)),
                                            subtitle: Text("${messages.last['type'] == 'text' ? messages.last['content'] : 'image'}",style: const TextStyle(fontWeight: FontWeight.normal,
                                                fontStyle: FontStyle.italic, fontSize: 11,fontFamily: 'ultra' ,color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }else{
                                return CircularProgressIndicator();
                              }
                            }
                        );
                      },
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                },
            )
        );
    }
  }
