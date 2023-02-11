

import 'package:dont_wait/Auth.dart';
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/services/Verify.dart';
import 'package:flutter/material.dart';
import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/header_widget.dart';


import 'home_screen.dart';




class Newpass extends StatefulWidget{
  final String? email;
  const Newpass({Key? key,this.email}): super(key:key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Newpass>{
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();

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
                      // Text(
                      //   'Dont Wait!',
                      //   style: TextStyle(fontSize: 40, fontFamily: 'ultra',  color: Colors.teal),
                      // ),
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
                                  controller: passwordController,
                                  decoration: ThemeHelper().textInputDecoration('New password', 'Enter new password'),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              Container(
                                decoration: ThemeHelper().inputBoxDecorationShaddow(),
                                child: TextField(
                                  controller: repeatPasswordController,
                                  obscureText: true,
                                  decoration: ThemeHelper().textInputDecoration('Repeat Password', 'Enter your password'),
                                ),
                              ),
                              const SizedBox(height: 15.0),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10,0,10,20),
                                alignment: Alignment.topRight,
                                // child: GestureDetector(
                                //   onTap: () {
                                //     Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                //   },
                                //   child:
                                //   Text( "", style: TextStyle( color: Colors.grey, ),
                                //   )
                                //   ,
                                // ),
                              ),
                              Container(
                                decoration: ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text('Reset'.toUpperCase(), style: const TextStyle(fontSize: 20,fontFamily: 'ultra' , color: Colors.white),),
                                  ),
                                  onPressed: ()async{
                                    if(passwordController.text.isNotEmpty && repeatPasswordController.text.isNotEmpty
                                    && passwordController.text == repeatPasswordController.text) {
                                      var isResseted = await resetPassword(email: widget.email!, newPassword: passwordController.text);
                                      if(isResseted){
                                        //After successful login we will redirect to profile page. Let's create profile page now
                                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Auth()));
                                      }
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.fromLTRB(10,20,10,20),
                                //child: Text('Don\'t have an account? Create'),
                                child: const Text.rich(
                                    TextSpan(
                                        children: [
                                          // TextSpan(text: "Don\'t have an account? "),
                                          // TextSpan(
                                          //   text: 'Create',
                                          //   recognizer: TapGestureRecognizer()
                                          //     ..onTap = (){
                                          //       Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationPage()));
                                          //     },
                                          //   style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).accentColor),
                                          // ),
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