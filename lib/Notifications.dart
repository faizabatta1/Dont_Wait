import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Notifications extends StatelessWidget {
  const Notifications ({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text("Notifications",style:TextStyle(
          fontSize: 20,
          fontFamily: 'ultra',
          color: Colors.white,

        ),),
        centerTitle: true,
      ),

      body: FutureBuilder(
        future: getUserNotifications(id: userId),
        builder: (context,snapshot){
          if(snapshot.hasData && !snapshot.hasError){
            List notifications = snapshot.data!;
            notifications.sort((n1,n2) => n2['timestamp'] - n1['timestamp']);

            return notifications.length > 0 ?ListView.builder(
                itemBuilder: (context,i){
                  Map notification = notifications[i];
                  return ListTile(
                    title: Text(notification['title']),
                    subtitle: Text(notification['body']),
                    trailing: Text(DateFormat('DD - MM hh:mm').format(DateTime.fromMillisecondsSinceEpoch(notification['timestamp']))),
                    leading: IconButton(
                      onPressed: ()async{
                        await deleteUserNotification(notification['id'].toString());
                        await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Notifications()));
                      },
                      icon: const Icon(Icons.delete_outline,color: Colors.red,size: 40,),
                    ),
                  );
                },
                itemCount: notifications.length
            ) : Center(
              child: Text('no notifications yet',style: TextStyle(fontSize: 30,color: Colors.teal),),
            );
          }else{
            return Container();
          }
        },
      ),
    );
  }
}
