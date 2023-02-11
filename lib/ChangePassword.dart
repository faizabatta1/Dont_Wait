import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Auth.dart';
import 'Signup/ThemeHelper.dart';
import 'home_screen.dart';
import 'login_page.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.teal,
              leading: GestureDetector(
                onTap: () {/* Write listener code here */},
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    size: 26.0,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen()));
                  },
                ),
              ),
            ),
            SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                // This will be the login form
                child: Column(
                  children: [
                    const Text(
                      'Update Your Password!',
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'ultra',
                          color: Colors.teal),
                    ),
                    const SizedBox(height: 30.0),
                    Form(
                      child: Column(
                        children: [
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextField(
                              controller: passwordController,
                              decoration: ThemeHelper().textInputDecoration(
                                  ' Old Password', 'Enter your Password'),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          Container(
                            decoration:
                                ThemeHelper().inputBoxDecorationShaddow(),
                            child: TextField(
                              controller: newPasswordController,
                              obscureText: true,
                              decoration: ThemeHelper().textInputDecoration(
                                  'New Password', 'Enter your password'),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          Container(
                            decoration:
                                ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text(
                                  'update'.toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'ultra',
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () async {
                                String id = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
                                await updateUserPassword(
                                    id: id,
                                    password: passwordController.text,
                                    newPassword: newPasswordController.text
                                ).then((updated){
                                  if(updated) {
                                    Utils.showSnackbar(context: context, message: "updated");
                                    Provider.of<AuthChangeNotifier>(context,listen: false).setUserType(UserType.UNKNOWN);
                                    Provider.of<AuthChangeNotifier>(context,listen: false).setUserData({});
                                    Provider.of<AuthChangeNotifier>(context,listen: false).setLoginStatus(false);

                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Auth()));
                                  }else{
                                    Utils.showSnackbar(context: context, message: "not updated");
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
