import 'package:dont_wait/constants/UserType.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class AuthChangeNotifier extends ChangeNotifier{
  late bool logged;
  late UserType userType;
  Map userData = {};

  AuthChangeNotifier({required this.logged,required this.userType,required this.userData});

  void setLoginStatus(bool loginStatus){
    logged = loginStatus;
    notifyListeners();
  }

  void setUserType(UserType userType){
    this.userType = userType;
  }

  void setUserData(Map data){
    userData = data;
  }
}