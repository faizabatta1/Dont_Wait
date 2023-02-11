import 'package:dont_wait/services/AuthChangeNotifier.dart';
import 'package:dont_wait/services/CentreChangeNotifier.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Auth.dart';
import 'Book.dart';
import 'Signup/ThemeHelper.dart';
import 'package:intl/intl.dart';

class DateAndTime extends StatelessWidget {
  final String centreId;
  final String test;
  const DateAndTime({Key? key, required this.test, required this.centreId }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //title: 'KindaCode.com',
      theme: ThemeData(
        // enable Material 3
        useMaterial3: true,
        primarySwatch: Colors.teal,
      ),
      home: HomePage(centreId:centreId,test:test),
    );
  }
}

class HomePage extends StatefulWidget {
  final String test;
  final String centreId;
  const HomePage({Key? key, required this.test, required this.centreId}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    timeInput.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: const Text( 'Choose Date And Time:', style: TextStyle(fontSize: 20, fontFamily: 'ultra',
            color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () { Navigator.pop(context); },
          child: IconButton(
            icon : Icon(
              Icons.arrow_back,
              size: 26.0,color: Colors.white,
            ),

            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => Book()));},

          ),
        ),

      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                  child: TextField(
                    controller: dateInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.calendar_today,color: Colors.teal,), //icon of text field
                        labelText: "Enter Date" //label text of field

                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2030));

                      if (pickedDate != null) {
                        setState(() {
                          dateInput.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                        });
                      } else {}
                    },

                  )
              ),
              Center(
                  child: TextField(
                    controller: timeInput,
                    //editing controller of this TextField
                    decoration: InputDecoration(
                        icon: Icon(Icons.timelapse,color: Colors.teal,), //icon of text field
                        labelText: "Enter Time" //label text of field
                    ),
                    readOnly: true,
                    //set it true, so that user will not able to edit text
                    onTap: () async {
                      TimeOfDay? pickedTime = await showTimePicker(
                          context: context,

                          initialTime: TimeOfDay(hour: 11, minute: 00)
                      );

                      if (pickedTime != null) {
                        setState(() {
                          timeInput.text = "${pickedTime.hour}-${pickedTime.minute}"; //set output date to TextField value.
                        });
                      } else {}
                    },

                  )
              ),
              const SizedBox(height: 300),
              Container(
                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text('book'.toUpperCase(), style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'ultra',
                        color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    //TODO: ENHANCE DATE AND TIME FORMAT

                    String userId = Provider.of<AuthChangeNotifier>(context,listen: false).userData['id'];
                    Map user = Provider.of<AuthChangeNotifier>(context,listen: false).userData;
                    String centre_name = Provider.of<CentreChangeNotifier>(context,listen: false).current_centre['placename'];
                    String patient_name = "${user['firstname']} ${user['lastname']}";
                    await bookAppointment(
                        centreId: widget.centreId,
                        date: dateInput.text,
                        time: timeInput.text,
                        typeOfTests: widget.test,
                        centre_name:centre_name,
                        patient_name:patient_name,
                        userId: userId
                    ).then((result){
                      if(result['success']){
                        Utils.showSnackbar(context: context, message: "added booking");
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Auth())
                        );
                      }else{
                        Utils.showSnackbar(context: context, message: "${result['message']}");
                      }
                    });
                  },
                ),
              )
            ]),
      ),


    );
  }
}

