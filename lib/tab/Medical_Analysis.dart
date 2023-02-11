import 'package:dont_wait/UpdateAppointment.dart';
import 'package:dont_wait/home_screen.dart';
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/CloudMessaging.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Signup/ThemeHelper.dart';
import '../services/FirestoreService.dart';
import '../services/Utils.dart';

class  Medical_Analysis extends StatefulWidget {
  @override
  State<Medical_Analysis> createState() => _Medical_AnalysisState();
}

class _Medical_AnalysisState extends State<Medical_Analysis> {
  late Future<List<dynamic>?>? reservations;
  @override
  void initState() {
    super.initState();
    String id = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
    reservations = getAllUserAppointments(id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: reservations,
      builder: (context, snapshot) {
        if(snapshot.hasData && !snapshot.hasError){
          List data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context,int i){
              var bookings = data[i];

              return Container(
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.grey[350],
                ),
                margin: EdgeInsets.all(8.0),

                child: Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: 10,),
                        Text("centre: ${bookings['centre_name']}"),
                        Text("test: ${bookings['test']}"),
                        Text("status: ${bookings['status']}"),
                        Text("date: ${bookings['date']}"),
                        Text("time: ${bookings['time']}"),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 30,
                          width: 110,
                          child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(color: Colors.teal,width: 30,height:30 ),

                              onPressed: () async{
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
                                  return UpdateAppointment(initialData: data[i]);
                                }));
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.0),

                                child: Text("update",style: const TextStyle(fontSize: 15,fontFamily: 'ultra' , color: Colors.white),),
                              )
                          ),
                        ),
                        SizedBox(width: 10,),
                        SizedBox(width: 110,
                        height: 30,
                          child: ElevatedButton(
                            style: ThemeHelper().buttonStyle().copyWith(
                              backgroundColor: MaterialStatePropertyAll(Colors.red),
                              minimumSize: MaterialStatePropertyAll(Size(30,30)),
                            ),
                            onPressed: ()async{
                              await deleteAppointment(id: data[i]['id']).then((status){
                                if(status){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                    return HomeScreen();
                                  }));
                                }else{
                                  Utils.showSnackbar(context: context, message: "failed to delete");
                                }
                              });
                            },
                            child: Text("delete",style: const TextStyle(fontSize: 15,fontFamily: 'ultra' , color: Colors.white),),
                          ),),

                      ],
                    )
                  ,  SizedBox(height: 10,)
                    //, Divider(),
                  ],

                ),

              );
            },
          );
        }
        return Center(
          child: Text("no data"),
        );
      },
    );
  }
}