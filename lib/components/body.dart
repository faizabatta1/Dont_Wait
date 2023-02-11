import 'package:dont_wait/components/background.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'login.dart';

class Body extends StatelessWidget {
  const Body({
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
return Background(

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  <Widget> [
          const Text('Login',style:TextStyle(
            fontSize: 30,
            fontFamily: 'ultra',
            color: Colors.teal, ),)

,
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            cursorColor: kPrimaryColor,
            onSaved: (email) {},
            decoration: const InputDecoration(
              hintText: "Your email",
              prefixIcon: Padding(
                padding: EdgeInsets.all(defaultPadding),
                child: Icon(Icons.person),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              textInputAction: TextInputAction.done,
              obscureText: true,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
              ),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btn",
           child: ElevatedButton(
              onPressed: () {
                //Navigator.push( context, MaterialPageRoute(builder: (context) =>  LoginScreen()),
              //  );
              },

              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 15, fontFamily: 'ultra'),
                fixedSize: const Size.fromWidth(120),
                backgroundColor:const Color(0xFF009688),

              ),
              child: const Text('Login User'),
            ),
          ),
          const SizedBox(height: defaultPadding),
          Hero(
            tag: "login_btnn",
            child: ElevatedButton(
              onPressed: () {
                Navigator.push( context, MaterialPageRoute(builder: (context) =>  LoginScreen()),
                 );
              },

              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16.0),
                textStyle: const TextStyle(fontSize: 15, fontFamily: 'ultra'),
                fixedSize: const Size.fromWidth(120),
                backgroundColor:const Color(0xFF009688),

              ),
              child: const Text('Login Centre'),
            ),
          ),
        ],
      ),
    );
  }
}