
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/components/appDrawer.dart';
import 'package:dont_wait/home_screen.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/splash_screen.dart';
import 'package:dont_wait/header_widget.dart';
import 'package:dont_wait/components/forgot_password_verification_page.dart';
import 'package:dont_wait/forgot_password_page.dart';

import 'package:dont_wait/Signup/registration_page.dart';
import 'package:provider/provider.dart';

import '../Book.dart';
import '../ChangeEmailAddress.dart';
import '../ChangePassword.dart';
import '../components/Edit_profile.dart';
import '../constants/UserType.dart';
import '../services/FirestoreService.dart';
import '../services/Utils.dart';
import 'ThemeHelper.dart';

class ProfilePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<AuthChangeNotifier>(context,listen: false).userData;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Profile Page",
            style: const TextStyle(fontWeight: FontWeight.normal,
                fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: Colors.white)
        ),
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace:Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Theme.of(context).primaryColor, Theme.of(context).colorScheme.secondary,]
              )
          ),
        ),
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.only( top: 16, right: 16,),
        //     child: Stack(
        //       children: <Widget>[
        //         const Icon(Icons.notifications),
        //         Positioned(
        //           right: 0,
        //           child: Container(
        //             padding: const EdgeInsets.all(1),
        //             decoration: BoxDecoration( color: Colors.red, borderRadius: BorderRadius.circular(6),),
        //             constraints: const BoxConstraints( minWidth: 12, minHeight: 12, ),
        //             child: const Text( '5', style: TextStyle(color: Colors.white, fontSize: 8,), textAlign: TextAlign.center,),
        //           ),
        //         )
        //       ],
        //     ),
        //   )
        // ],
      ),
      drawer: AppDrawer(scaffoldKey: _scaffoldKey,),
      body: SingleChildScrollView(
      child: Stack(
        children: [
        const SizedBox(height: 100, child: HeaderWidget(100,false,Icons.house_rounded),),
      Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          children: [
            Container(

              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(

                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 5, color: Colors.white),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(color: Colors.white, blurRadius: 20, offset: Offset(5, 5),),
                ],
              ),
              child: Image.network(userData['image']),
            ),
          //  const SizedBox(height: 12,),

            Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  // Container(
                  //   padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  //   alignment: Alignment.topLeft,
                  //   child: const Text(
                  //     "User Information",style: const TextStyle(fontWeight: FontWeight.normal,
                  //       fontStyle: FontStyle.italic, fontSize: 18,fontFamily: 'ultra' ,color: Colors.teal),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Card(

                    borderOnForeground: true,
                    shadowColor: Colors.teal,
                    elevation: 7,
                  child: ListTile(
                    hoverColor: Colors.teal,
                  selectedTileColor: Colors.cyan,
                    horizontalTitleGap: 6.0,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  leading: const Icon(Icons.person_outline,color: Colors.teal,),
                  title: const Text("Name :",style: const TextStyle(fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                  subtitle: Text("${userData['firstname']} ${userData['lastname']}",style: const TextStyle(fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                                  ),

                  ),
                  SizedBox(height: 7,),
                  Card(
                    borderOnForeground: true,
                    shadowColor: Colors.teal,
                    elevation: 7,
                    child: ListTile(
                      horizontalTitleGap: 6.0,
                      leading: const Icon(Icons.email_outlined,color: Colors.teal,),
                      title: const Text("Email :",style: const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                      subtitle: Text("${userData['email']}",style: const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                    ),
                  )
                  ,
                  SizedBox(height: 7,),
                  Card(
                    borderOnForeground: true,
                    shadowColor: Colors.teal,
                    elevation: 7,
                    child: ListTile(
                      horizontalTitleGap: 6.0,
                      leading: const Icon(Icons.phone_android_outlined,color: Colors.teal,),
                      title: const Text("Phone :",style: const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                      subtitle: Text("${userData['phone']}",style: const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                    ),
                  )
                  ,
                  SizedBox(height: 7,),
                  Card(
                    borderOnForeground: true,
                    shadowColor: Colors.teal,
                    elevation: 7,
                    child: ListTile(
                      horizontalTitleGap: 6.0,
                      leading: const Icon(Icons.transgender_outlined,color: Colors.teal,),
                      title: const Text("Gender :",style: const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                      subtitle: Text("${userData['gender']}",style:  const TextStyle(fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic, fontSize: 13,fontFamily: 'ultra' ,color: Colors.black)),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      )
      ],
      ),
      ),
    );
  }

}