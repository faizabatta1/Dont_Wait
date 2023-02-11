
import 'dart:convert';

import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:dont_wait/table.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/header_widget.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import 'CreateAccount.dart';
import 'SignupCentre.dart';
import 'forgot_password_page.dart';
import 'package:dont_wait/Signup/registration_page.dart';

import 'home_screen.dart';





class LoginPage extends StatefulWidget{
  const LoginPage({Key? key}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final idController = TextEditingController();
  final passwordController = TextEditingController();
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, false, Icons.person), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),// This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Dont Wait!',
                        style: TextStyle(fontSize: 40, fontFamily: 'ultra',  color: Colors.teal),
                      ),
                      // Text(
                      //   'Sign in into your account',
                      //   style: TextStyle(color: Colors.grey),
                      // ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: idController,
                                  decoration: ThemeHelper().textInputDecoration('User Id', 'Enter your iD'),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: passwordController,

                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Password', 'Enter your password'),
                                ),
                              ),
                            const  SizedBox(height: 15.0),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push( context, MaterialPageRoute( builder: (context) => const ForgotPasswordPage()), );
                                  },
                                  child: const Text( "Forgot your password?", style: TextStyle( color: Colors.grey, ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),

                                    child: Text('Log In'.toUpperCase(), style: const TextStyle(fontSize: 18,fontFamily: 'ultra' , color: Colors.white),),
                                  ),
                                  onPressed: () async{
                                    UserType userType = await determineUserType(idController.text);
                                    SharedPreferences sp = await SharedPreferences.getInstance();

                                    if(userType == UserType.NORMAL){
                                      await loginUser(id: idController.text, password: passwordController.text).then((data) async{
                                        if(data['success']){
                                          String token = (await CloudMessaging.getToken())!;
                                          await updateUserToken(id: idController.text, device_token: token);
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setUserType(userType);
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setUserData(data['userData']);
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(true);
                                          await sp.setString('userData', jsonEncode(data['userData']));
                                        }else{
                                          Utils.showSnackbar(context: context, message: data['message']);
                                        }
                                      });
                                    }else if(userType == UserType.CENTRE){
                                      await loginCentre(id: idController.text, password: passwordController.text).then((centre) async{
                                        if(centre['matched']){
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setUserType(userType);
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setUserData(centre['data']);
                                          Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(true);
                                          await sp.setString('userData', jsonEncode(centre['data']));
                                        }else{
                                          Utils.showSnackbar(context: context, message: "centre couldn't be logged");
                                        }
                                      });
                                    }
                                    await sp.setString('id', idController.text);
                                    await sp.setBool('logged', true);
                                  },
                                ),
                              ),
                              // const SizedBox(height: 16.0),
                              // Container(
                              //   decoration: ThemeHelper().buttonBoxDecoration(context),
                              //   child: ElevatedButton(
                              //     style: ThemeHelper().buttonStyle(),
                              //     child: Padding(
                              //       padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                              //       child: Text('Log In Centre'.toUpperCase(), style: const TextStyle(fontSize: 15,fontFamily: 'ultra' , color: Colors.white),),
                              //     ),
                              //     onPressed: () async{
                              //       var logged = await loginCentre(
                              //         id:idController.text,
                              //         password:passwordController.text
                              //       );
                              //
                              //       if(logged){
                              //         Navigator.pushReplacement(context,
                              //             MaterialPageRoute(
                              //                 builder: (context) => table()
                              //             )
                              //         );
                              //       }else{
                              //         final snackBar = new SnackBar(content: new Text("invalid centre"),duration: const Duration(seconds: 2),);
                              //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              //       }
                              //     },
                              //   ),
                              // ),

                              Container(
                                margin: const EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          const TextSpan(text: "Don't have an account? "),
                                          TextSpan(
                                            text: 'Create',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(60,5,10,5),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(
                                    TextSpan(
                                        children: [
                                          const TextSpan(text: " Are you medical center and don't have an account? "),
                                          TextSpan(
                                            text: 'Sign up',
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = (){
                                                Navigator.push(context, MaterialPageRoute(builder: (context) => CentreRegistration()));
                                              },
                                            style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
                                          ),

                                        ]
                                    )

                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      ),
    );

  }
}