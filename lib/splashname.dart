import 'package:dont_wait/Auth.dart';
import 'package:flutter/material.dart';


import 'login_page.dart';
class splash_screen2 extends StatefulWidget {
  const splash_screen2({ Key? key }):super(key:key);

  @override
  State<splash_screen2> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen2> {
  @override
  void initState(){
    super.initState();
    _navigatetohome();
  }
  _navigatetohome()async{ await Future.delayed(const Duration(milliseconds: 4000),(){});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Auth()));}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
            "Don't Wait !",
            style: TextStyle(
                fontSize: 30,
             fontFamily: 'ultra',
              shadows: [
                Shadow(
                    color: Colors.teal,
                    offset: Offset(0, -5))
              ],
              color: Colors.transparent,

            ),
          ),

 ),

    );
  }
}