import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/constants/MessageType.dart';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class ChatScreen extends StatefulWidget {
  final String subscriber;
  final String publisher;
  final String subscriber_name;
  const ChatScreen({Key? key, required this.subscriber, required this.publisher, required this.subscriber_name}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  FirebaseFirestore database = FirebaseFirestore.instance;
  FocusNode focusNode = FocusNode();


  ScrollController _scrollController = new ScrollController();

  Future pushMessage(MessageType messageType) async{
    UserType userType = Provider.of<AuthChangeNotifier>(context,listen: false).userType;
    final user = Provider.of<AuthChangeNotifier>(context,listen: false).userData;
    if(userType == UserType.NORMAL){
      await FirestoreService.pushMessage(
          publisher: widget.publisher,
          subscriber: widget.subscriber,
          content: messageType == MessageType.TEXT ? messageController.text : (await getImageBase64()),
          subscriber_name:widget.subscriber_name,
          publisher_name:'${user['firstname']} ${user['lastname']}',
          messageType: messageType
      );
    }else{
      await FirestoreService.pushMessage(
          publisher: widget.subscriber,
          subscriber: widget.publisher,
          content: messageType == MessageType.TEXT ? messageController.text : (await getImageBase64()),
          subscriber_name:widget.subscriber_name,
          publisher_name: '${user['placename']}',
          messageType: messageType
      );
    }

    messageController.text = "";
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }
  File? file;

  Future<void> openStudio() async{
    file = File((await ImagePicker.platform.getImage(source: ImageSource.gallery))!.path);
  }

  Future<String> getImageBase64() async{
    String base64Image = base64Encode(await file!.readAsBytes());
    return base64Image;
  }


  @override
  void initState() {
    super.initState();
    focusNode.requestFocus();
    _scrollController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(widget.subscriber_name,style: TextStyle(color: Colors.white),),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                  stream: FirestoreService.firestore.collection("messages").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                    if(snapshot.hasData && !snapshot.hasError){
                      List<Widget> messagesWidgets = [];
                      List messages = snapshot.data!.docs.where((element){
                        return (element['publisher'] == widget.publisher && element['subscriber'] == widget.subscriber)
                            || (element['publisher'] == widget.subscriber && element['subscriber'] == widget.publisher);
                      }).toList();

                      messages.sort((a,b){
                        return a.get("timestamp").toString().compareTo(b['timestamp'].toString());
                      });

                      messages = messages.reversed.toList();

                      for(var message in messages){
                        final messageText = message.get("content");
                        final messageSender = message.get("publisher");
                        final messageType = message.get('type');
                        final messageStamp = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(message.get("timestamp")));
                        UserType userType = Provider.of<AuthChangeNotifier>(context,listen: false).userType; // responsible for siding
                        if(userType == UserType.NORMAL){
                          if(messageSender == widget.publisher){
                            messagesWidgets.add(
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      child:messageType == 'text' ? Text(
                                        "$messageStamp  $messageText",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ) : Image.memory(base64Decode(messageText)),
                                      onLongPress: ()async{
                                        await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              actions: [
                                                TextButton(onPressed: (){

                                                }, child: Text('delete')),
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                ),

                            );
                          }else{
                            messagesWidgets.add(
                              Container(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: messageType == 'text' ? Text(
                                    "$messageText  $messageStamp",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ) : GestureDetector(
                                    child: Image.memory(base64Decode(messageText)),
                                    onLongPress: ()async{
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(onPressed: (){
                                              }, child: Text('delete')),
                                            ],
                                          )
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          }
                        }else if(userType == UserType.CENTRE){
                          if(messageSender == widget.publisher){
                            messagesWidgets.add(
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.80,
                                    ),
                                    padding: EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: GestureDetector(
                                      child:messageType == 'text' ? Text(
                                        "$messageStamp - $messageText",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ) : Image.memory(base64Decode(messageText)),
                                      onLongPress: ()async{
                                        await showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              actions: [
                                                TextButton(onPressed: (){

                                                }, child: Text('delete')),
                                              ],
                                            )
                                        );
                                      },
                                    ),
                                  ),
                                ),
                            );
                          }else{
                            messagesWidgets.add(
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.80,
                                  ),
                                  padding: EdgeInsets.all(10),
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    child:messageType == 'text' ? Text(
                                      "$messageStamp - $messageText",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ) : Image.memory(base64Decode(messageText)),
                                    onLongPress: ()async{
                                      await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            actions: [
                                              TextButton(onPressed: (){

                                              }, child: Text('delete')),
                                            ],
                                          )
                                      );
                                    },
                                  )
                                ),
                              ),
                            );
                          }
                        }

                      }
                      return ListView(
                        controller: _scrollController,
                        reverse: true,
                        shrinkWrap: true,
                        children: messagesWidgets,
                      );
                    }else{
                      return CircularProgressIndicator();
                    }
                  },
                ),
              ),
              SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        border: OutlineInputBorder()
                      ),
                    ),
                    flex: 1,
                  ),
                  IconButton(
                      onPressed: () async{
                        await openStudio().then((value){
                          pushMessage(MessageType.IMAGE);
                        });
                      },
                      icon: Icon(Icons.image_outlined,size: 40,)
                  ),
                  ElevatedButton(
                      onPressed: ()async{
                        if(messageController.text != "") {
                          await pushMessage(MessageType.TEXT);
                        } else{
                          Utils.showSnackbar(context: context, message: "please enter something");
                        }
                        // messagesStreaming();
                      },
                      child: Icon(Icons.send,color: Colors.white,)
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
