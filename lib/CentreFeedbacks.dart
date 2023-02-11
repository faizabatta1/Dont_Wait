import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';

class CentreFeedbacks extends StatefulWidget {
  final Map centre;
  const CentreFeedbacks({Key? key,required this.centre}) : super(key: key);

  @override
  State<CentreFeedbacks> createState() => _CentreFeedbacksState();
}

class _CentreFeedbacksState extends State<CentreFeedbacks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recent feedbacks'),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: FutureBuilder(
              future: getFeedbacks(centreId: widget.centre['id']),
              builder: (context,AsyncSnapshot snapshot){
                if(snapshot.hasData && !snapshot.hasError){
                  List feedbacks = snapshot.data;
                  return Container(
                    width: double.infinity,
                    height: 400,
                    child: feedbacks.length > 0 ?ListView.builder(
                      itemCount: feedbacks.length,
                      itemBuilder: (context,i){
                        Map feedback = feedbacks[i];
                        return ListTile(
                          trailing: Text('${feedback['rating']}',style: TextStyle(fontSize: 20),),
                          title: Text(feedback['patient_name'],style: TextStyle(fontSize: 20)),
                          subtitle: Text(feedback['comment'],style: TextStyle(fontSize: 20)),
                        );
                      },
                    ) : Center(
                      child: Text('no feedbacks yet',style: TextStyle(fontSize: 30,color: Colors.teal),),
                    ),
                  );
                }else{
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
