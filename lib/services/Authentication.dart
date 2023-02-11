import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/services/FirebaseUtils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'AuthChangeNotifier.dart';
import 'CloudMessaging.dart';
import 'FirestoreService.dart';

class Authentication{
  static FirebaseAuth auth = FirebaseAuth.instance;

  static Future registerAccountWithEmailAndPassword({required String email,required String password}) async{
    try{
      UserCredential result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      return true;
    } on FirebaseAuthException catch(error){
      return false;
    }
  }



  static Future signInWithEmailAndPassword({required String email,required String password}) async{
    String uid = (await auth.signInWithEmailAndPassword(email: email, password: password)).user!.uid;
    return uid;
  }


  //onyl user have tokens
  static Future updateUserToken(String uid) async{
    String? device_token = await CloudMessaging.getToken();
    var ref = await FirebaseUtils.getDocumentRef(collection: "users", uid: uid);
    await FirestoreService.updateUser(newDate: {
      'device_token':device_token
    }, ref: ref);
  }

  static Future removeUserToken(String uid) async{
    var ref = await FirebaseUtils.getDocumentRef(collection: "users", uid: uid);
    await FirestoreService.updateUser(newDate: {
      'device_token':''
    }, ref: ref);
  }

  //logout for both and separate token handling
  static Future logout(BuildContext context) async{
    // Provider.of<AuthChangeNotifier>(context,listen: false).setUserType(UserType.UNKNOWN);
    // var provider = Provider.of<AuthChangeNotifier>(context,listen: false);
    // if(provider.isGoogle) provider.setIsGoogle(false);
    //
    // if(auth.currentUser!.providerData[0].providerId == "google.com"){
    //   await auth.signOut();
    //   await GoogleSignIn().disconnect();
    //   await GoogleSignIn().signOut();
    // }else{
    //   await auth.signOut();
    // }
  }

  static Future<String?> signInWithGoogle() async {

    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    User? firebaseUser = (await auth.signInWithCredential(credential)).user;

    return firebaseUser?.uid;
  }

}