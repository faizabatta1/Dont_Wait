import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dont_wait/ChatScreen.dart';
import 'package:dont_wait/EmergencyMessage.dart';
import 'package:dont_wait/ReportResult.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:dont_wait/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class BookingDetails extends StatefulWidget {
  final Map booking;
  BookingDetails({required this.booking});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool isApproved = false;

  @override
  Widget build(BuildContext context) {
    isApproved = widget.booking['status'] == "approved";

    return Scaffold(
      floatingActionButton: isApproved ? FloatingActionButton(
        child: Icon(Icons.chat_bubble),
        onPressed: () async{
          await Navigator.push(context,MaterialPageRoute(builder: (context){
            return ChatScreen(
                subscriber: widget.booking['centreId'],
                publisher: widget.booking['patientId'],
                subscriber_name: '${widget.booking['patient_name']}'
            );
          }));
        },
      ) : null,
      appBar: AppBar(
        backgroundColor: Colors.teal,

        title: Text(
            widget.booking['test'],
            style: TextStyle(fontSize: 20, fontFamily: 'ultra',  color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            shape: const RoundedRectangleBorder(
              side: BorderSide(
                color: Colors.teal,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Padding(

              padding: const EdgeInsets.all(20.0),

              child: SizedBox(
                width: 300,
                height: 110,
                 child: Column(
                  children: [

                    Text(widget.booking['patient_name'],style: TextStyle(fontSize: 20, fontFamily: 'ultra',  color: Colors.teal)),
                    Text(widget.booking['test'],style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.teal)),
                    Text(widget.booking['date'],style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.teal)),
                    Text(widget.booking['time'],style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.teal)),
                    Text(widget.booking['status'],style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.teal)),
                  ]
                ),
              ),

            ),
          ),
          SizedBox(height: 20,),
          isApproved ? Container() : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                height: 40,
                width: 140,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.teal),
                        animationDuration: Duration(seconds: 3)
                    ),
                    onPressed: () async{
                      bool result = await showDialog(context: context, builder: (context){
                        return ActionConfirm(message: "are you sure you want to accept this booking?",);
                      });

                      if(!result) return;
                      else{
                        await updateAppointmentStatus(
                            id: widget.booking['id'].toString(),
                            newStatus: "approved"
                        ).then((value){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => table()));
                        }).catchError((onError){
                          print("$onError");
                        });
                      }
                    },

                    child: Text("approve".toUpperCase(),style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.white))),
              ),
             SizedBox(
               height: 40,
               width: 140,
               child: ElevatedButton(
                   style: ButtonStyle(
                       backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                       animationDuration: Duration(seconds: 3)
                   ),
                   onPressed: () async{
                     bool result = await showDialog(context: context, builder: (context){
                       return ActionConfirm(message: "are you sure you want to decline this booking?",);
                     });

                     if(result){
                       var token = await getUserToken(id: widget.booking['patientId']);
                       await CloudMessaging.sendPushMessage("booking was cancelled", widget.booking['centre_name'], token);

                       await deleteAppointment(id: widget.booking['id']).then((value){
                         Navigator.of(context).push(MaterialPageRoute(builder: (contect){
                           return table();
                         }));
                       });
                     }else{
                       return;
                     }
                   },
                   child: Text("decline".toUpperCase(),style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.white))
               ),
             )
            ],
          ),
          SizedBox(height: 30,),
          !isApproved ? Container() : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 140,
                height: 40,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.teal),
                          animationDuration: Duration(seconds: 3)
                      ),
                      onPressed: () async{
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReportResult(test:widget.booking)));
                      },

                      child: Text("result".toUpperCase(),style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.white)))
              )
              ,
             SizedBox(
               height: 40,
               width: 140,
               child:  ElevatedButton(
                   style: ButtonStyle(
                       backgroundColor: MaterialStatePropertyAll(Colors.redAccent),
                       animationDuration: Duration(seconds: 3)
                   ),
                   onPressed: () async{
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return EmergencyMessage(booking:widget.booking);
                      }));
                   },
                   child: Text("emergency",style: TextStyle(fontSize: 15, fontFamily: 'ultra',  color: Colors.white))
               ),
             ),
            ],
          )
        ],
      )
    );
  }
}

class ActionConfirm extends StatelessWidget{
  final String message;
  ActionConfirm({super.key,required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pop(true);
        }, child: Text("yes")),
        TextButton(onPressed: (){
          Navigator.of(context).pop(false);
        }, child: Text("no")),
      ],
      content: Text(message),
    );
  }

}