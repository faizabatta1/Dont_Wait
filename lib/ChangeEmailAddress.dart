// import 'package:dont_wait/Auth.dart';
// import 'package:dont_wait/services/Authentication.dart';
// import 'package:dont_wait/services/FirestoreService.dart';
// import 'package:dont_wait/services/Utils.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import 'Signup/ThemeHelper.dart';
// import 'home_screen.dart';
// import 'login_page.dart';
//
// class ChangeEmailAddress extends StatefulWidget {
//   const ChangeEmailAddress({Key? key}) : super(key: key);
//
//   @override
//   State<ChangeEmailAddress> createState() => _ChangeEmailAddressState();
// }
//
// class _ChangeEmailAddressState extends State<ChangeEmailAddress> {
//
//   TextEditingController newEmailController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//         AppBar(
//           backgroundColor: Colors.teal,
//         leading: IconButton(
//           icon : Icon(
//             Icons.arrow_back,
//             size: 26.0,color: Colors.white,
//           ),
//
//           onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));},
//
//         ),
//       ),
//
//             SafeArea(
//               child: Container(
//                 padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
//                 // This will be the login form
//                 child: Column(
//                   children: [
//                     const Text(
//                       'Update Your Emai!',
//                       style: TextStyle(fontSize: 25,
//                           fontFamily: 'ultra',
//                           color: Colors.teal),
//                     ),
//                     const SizedBox(height: 30.0),
//                     Form(
//
//                       child: Column(
//                         children: [
//                           Container(
//                             decoration: ThemeHelper()
//                                 .inputBoxDecorationShaddow(),
//                             child: TextField(
//                               controller: newEmailController,
//                               decoration: ThemeHelper().textInputDecoration(
//                                   'User  new Email', 'Enter your Email'),
//                             ),
//                           ),
//                           const SizedBox(height: 30.0),
//                           Container(
//                             decoration: ThemeHelper()
//                                 .inputBoxDecorationShaddow(),
//                             child: TextField(
//                               controller: passwordController,
//
//                               obscureText: true,
//                               decoration: ThemeHelper().textInputDecoration(
//                                   'Password', 'Enter your password'),
//                             ),
//                           ),
//                           const SizedBox(height: 15.0),
//
//                           Container(
//                             decoration: ThemeHelper().buttonBoxDecoration(
//                                 context),
//                             child: ElevatedButton(
//                               style: ThemeHelper().buttonStyle(),
//                               child: Padding(
//                                 padding: const EdgeInsets.fromLTRB(
//                                     40, 10, 40, 10),
//
//                                 child: Text('update'.toUpperCase(),
//                                   style: const TextStyle(fontSize: 18,
//                                       fontFamily: 'ultra',
//                                       color: Colors.white),),
//                               ),
//                               onPressed: () async {
//                                 var currentUserEmail = Authentication.auth
//                                     .currentUser!.email;
//                                 AuthCredential credential = EmailAuthProvider
//                                     .credential(email: currentUserEmail!,
//                                     password: passwordController.text);
//                                 try {
//                                   await Authentication.auth.currentUser!
//                                       .reauthenticateWithCredential(credential);
//                                   await Authentication.auth.currentUser!
//                                       .updateEmail(newEmailController.text);
//                                   Navigator.of(context).pushReplacement(
//                                       MaterialPageRoute(builder: (context) {
//                                         return LoginPage();
//                                       }));
//                                 } on FirebaseAuthException catch (error) {
//                                   return Utils.showSnackbar(context: context,
//                                       message: "${error.message}");
//                                 };
//                               }
//                               ,),),
//                         ],),),
//                   ],
//                 ),
//               ),
//             ),
//           ],),),);
//
//   }}
//
//
