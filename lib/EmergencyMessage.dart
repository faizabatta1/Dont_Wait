import 'package:dont_wait/BookingDetails.dart';
import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/table.dart';
import 'package:flutter/material.dart';

class EmergencyMessage extends StatelessWidget {
  final Map booking;
  EmergencyMessage({Key? key, required this.booking}) : super(key: key);
  final TextEditingController emergencyMessage = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.emergency_outlined,color: Colors.white,size: 30,),
          onPressed: () async{
            Navigator.push(context, MaterialPageRoute(builder: (context) =>table()));
          },

        ),
        backgroundColor: Colors.teal,
        title: Text("emergency notification page",style:TextStyle(
          fontSize: 15,
          fontFamily: 'ultra',
          color: Colors.white,

        )),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
                child: Column(
                children: [
                  TextFormField(

                    decoration: ThemeHelper()
                        .textInputDecoration("emergency message","enter message for patient"),
                    validator: (val){
                      if(val!.isEmpty) return "please enter something"; // remove the first ! for the logic
                    },
                    controller: emergencyMessage,
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(

                      onPressed: ()async{
                        // String? token = await getUserToken(id: booking['patientId']);
                        String? token = await CloudMessaging.getToken();
                        if(token != null){
                          await CloudMessaging.sendPushMessage(emergencyMessage.text, booking['centre_name'], token,userId: booking['patientId']);
                        }else{
                          Utils.showSnackbar(context: context, message: "user is not logged in");
                        }
                      }, style: ThemeHelper().buttonStyle(),
                      child: Text("send notification",style:TextStyle(
                        fontSize: 13,
                        fontFamily: 'ultra',
                        color: Colors.white,

                      ),))
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}

