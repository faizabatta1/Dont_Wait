import 'package:dont_wait/Signup/registration_page.dart';
import 'package:dont_wait/SignupCentre.dart';
import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Signup/ThemeHelper.dart';

class CreateAccount extends StatefulWidget {
  final UserType userType;
  const CreateAccount({Key? key, required this.userType}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          leading: GestureDetector(
            onTap: () { /* Write listener code here */ },
            child: IconButton(
              icon : Icon(
                Icons.arrow_back,
                size: 26.0,color: Colors.white,
              ),

              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));},

            ),
          ),
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                  // key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        decoration: ThemeHelper().inputBoxDecorationShaddow(),
                        child: TextField(
                          controller: emailController,
                          decoration: ThemeHelper().textInputDecoration('Email', 'Enter your Email'),
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
                        decoration: ThemeHelper().buttonBoxDecoration(context),
                        child: ElevatedButton(
                          style: ThemeHelper().buttonStyle(),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),

                            child: Text('next'.toUpperCase(), style: const TextStyle(fontSize: 18,fontFamily: 'ultra' , color: Colors.white),),
                          ),
                          onPressed: () async{
                            bool passed = await Authentication.registerAccountWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text
                            );

                            if(passed){
                              User user = Authentication.auth.currentUser!;
                              user.sendEmailVerification().whenComplete((){
                                Utils.showSnackbar(context: context, message: "verification link has been sent to your email");
                                String uid = user.uid;
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                  switch(widget.userType){
                                    case UserType.NORMAL:
                                      return RegistrationPage();
                                    case UserType.CENTRE:
                                      return CentreRegistration();
                                    case UserType.UNKNOWN:
                                      return LoginPage();
                                  }
                                }));

                              });
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("something went wrong"))
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
