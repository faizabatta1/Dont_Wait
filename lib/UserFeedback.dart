import 'package:dont_wait/Signup/ThemeHelper.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class UserFeedback extends StatefulWidget {
  final Map<String, dynamic> report;
  const UserFeedback({Key? key, required this.report}) : super(key: key);

  @override
  State<UserFeedback> createState() => _FeedbackState();
}

class _FeedbackState extends State<UserFeedback> {
  double rating = 0.0;
  TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('feedback',style: TextStyle(color: Colors.white),),
        centerTitle: true,
      ),
      body: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RatingBar.builder(
              initialRating: 0,
                minRating: 0,
                maxRating: 5,
                itemBuilder: (context,index){
                  return Icon(Icons.star,color: Colors.teal,);
                },
                onRatingUpdate: (value){
                  rating = value;
                },
              allowHalfRating: true,
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: feedbackController,
              maxLines: 10,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  hintText: "write Feedback",
                  label: Text("Feedback",style:TextStyle(
                    fontSize: 15,
                    fontFamily: 'ultra',
                    color: Colors.teal,

                  ),)
              ),
            ),
            Container(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.teal)
                ),
                onPressed: ()async{
                  if(feedbackController.text.isNotEmpty){
                    await pushFeedback(
                        patient_name: widget.report['patient_name'],
                        rating: rating,
                        comment: feedbackController.text,
                        patient_id: widget.report['patient_id'],
                        centre_id: widget.report['centre_id'],
                        centre_name: widget.report['centre_name']
                    ).then((value){
                      Navigator.pop(context);
                    });
                  }else{
                    Utils.showSnackbar(context: context, message: "please enter something");
                  }
                },
                child: Text('publish'.toUpperCase(),style: TextStyle(color: Colors.white),),
              ),
            )
          ],
        ),
      ),
    );
  }
}
