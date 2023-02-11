import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/ChatScreen.dart';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/home_screen.dart';
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'BookingDetails.dart';
import 'CHAT.dart';
import 'Signup/ThemeHelper.dart';

void main() {runApp(table());}

class table extends StatefulWidget {
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<table> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text('Medical Center Records'),
            actions: [
              StreamBuilder(
                stream: FirestoreService.firestore.collection("messages").snapshots(),
                builder: (context, snapshot) {
                  if(snapshot.hasData && !snapshot.hasError){
                    String uid = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
                    Set publishers = Set();
                    var publisherMessages = snapshot.data!.docs.where((element) => element['subscriber'] == uid).toList();

                    for(var message in publisherMessages){
                      publishers.add(message['publisher']);
                    }

                    List totalContacts = publishers.toList();

                    return Badge(
                      child: IconButton(
                          onPressed: () async {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context){
                              return chat(subscriber: uid);
                            }));
                          },
                          icon: Icon(Icons.chat_bubble,)
                      ),
                      badgeContent: Text(totalContacts.length.toString(), style: TextStyle(color: Colors.white),),
                      badgeColor: Colors.red,
                    );
                  }else{
                    return CircularProgressIndicator();
                  }
                }
              ),
              IconButton(
                  onPressed: ()async{
                    Provider.of<AuthChangeNotifier>(context,listen: false).setUserData({});
                    Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(false);
                    SharedPreferences sp = await SharedPreferences.getInstance();
                    await sp.setBool('logged', false);
                    await sp.setString('userData', '{}');
                    await sp.setString('id', '');

                    await Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Auth()));
                    },
                  icon: Icon(Icons.logout)
              )
            ],
          ),
          body: Column(children: <Widget>[
            SizedBox(height: 10,),
            Expanded(
              child: FutureBuilder(
                future: getAllCentreAppointments(Provider.of<AuthChangeNotifier>(context,listen: false).userData['id']),
                builder: (BuildContext context, snapshot) {
                  if(snapshot.hasData && !snapshot.hasError){
                    List data = snapshot.data!;

                    return ListView.separated(
                        itemBuilder: (BuildContext context,int i){
                          return InkWell(
                            onTap: () async{
                              if(data[i]['status'] == "pending"){
                                await updateAppointmentStatus(
                                    id: "${data[i]['id']}",
                                    newStatus: "viewed"
                                );
                              }

                              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                                return BookingDetails(booking: data[i]);
                              }));
                            },

                            child: Container(
                              height: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.teal,
                                boxShadow: [BoxShadow(color: Colors.black, blurRadius: 10, spreadRadius: 5)],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                  bottomRight: Radius.circular(40),
                                  bottomLeft: Radius.circular(40),
                                ),
                              ),
                              child: FutureBuilder(
                                  future: getUserData(data[i]['patientId']),
                                builder: (context,snapshot){
                                    if(snapshot.hasData && !snapshot.hasError){
                                      Map user = snapshot.data!;

                                      return ListTile(
                                        shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 3, color: Colors.teal),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        selected: data[i]['status'] != "pending",
                                        selectedTileColor: data[i]['status'] == "viewed" ? Colors.yellow : Colors.teal,

                                        title: Text("${user['firstname']} ${user['lastname']}",style: TextStyle(fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: (data[i]["status"] != "pending") ? Colors.white : Colors.black)),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.teal,
                                          backgroundImage: NetworkImage(user['image']),
                                        ),
                                        trailing: Text("${data[i]['date']} - ${data[i]['time']}",style: TextStyle(fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic, fontSize: 12,fontFamily: 'ultra' ,color: (data[i]["status"] != "pending") ? Colors.white : Colors.black)),
                                        subtitle: Text("${data[i]['test']}",style: TextStyle(fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic, fontSize: 12,fontFamily: 'ultra' ,color: (data[i]["status"] != "pending") ? Colors.white : Colors.black)),
                                      );
                                    }else{
                                      return CircularProgressIndicator();
                                    }
                                },
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context,i){
                          return Divider(height: 2,);
                        },
                        itemCount: data.length
                    );
                  }else{
                    return Container();
                  }
                },

              ),
            ),
          ])
      ),
    );
  }
}
