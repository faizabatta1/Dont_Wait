import 'package:dont_wait/constants/UserType.dart';
import 'package:dont_wait/home_screen.dart';
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Auth extends StatelessWidget {
  Auth({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final logged = Provider.of<AuthChangeNotifier>(context).logged;
    final userType = Provider.of<AuthChangeNotifier>(context).userType;
    if(logged){
      // acts like a centre
      return userType == UserType.NORMAL ? HomeScreen() : table();
    }else{
      return LoginPage();
    }
  }
}
