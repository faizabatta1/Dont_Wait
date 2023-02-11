
import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Report.dart';
import '../services/FirestoreService.dart';

class  Medical_Guidelines extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:  BoxDecoration(
        // borderRadius: BorderRadius.circular(30),
        // color: Colors.grey[350],//                    <-- BoxDecoration
        border: Border(bottom: BorderSide(),

        ),
      ),
      child: FutureBuilder(
        future: getUserReports(Provider.of<AuthChangeNotifier>(context,listen: false).userData['id']),
        builder: (BuildContext context, snapshot) {
          if(snapshot.hasData && !snapshot.hasError){
            List data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,

              itemBuilder: (context,i){
                var tile = data[i];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Report(reportData: tile,);
                    }));
                  },
                  child: ListTile(

                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.medication_outlined,color: Colors.white,),
                    ),
                    trailing: Icon(Icons.open_in_new ,color: Colors.teal,),
                    title: Text(tile['test_type'].toString(),style:const TextStyle(
                      fontSize: 15,
                      fontFamily: 'ultra',
                      color: Colors.teal,

                    ),),
                    subtitle: Text(tile['centre_name'],style:const TextStyle(
                      fontSize: 15,
                      fontFamily: 'ultra',
                      color: Colors.teal,

                    ),),

                  ),

                );
            });
          }else{
            return Container();
          }
        },
      ),
    );
  }
}