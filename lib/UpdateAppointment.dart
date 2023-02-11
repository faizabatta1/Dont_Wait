import 'package:chewie/chewie.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'Signup/ThemeHelper.dart';

class UpdateAppointment  extends StatefulWidget {
  final Map<String,dynamic> initialData;


  const UpdateAppointment({super.key,required this.initialData});

  @override
  State<UpdateAppointment> createState() => _UpdateAppointmentState();
}

class _UpdateAppointmentState extends State<UpdateAppointment> {
  final TextEditingController testController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();


  void _showMultiSelect() async {
    List items = await getCentreTests(widget.initialData['centreId']);

    final String? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        testController.text = results;
        widget.initialData['test'] = results;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    testController.text = widget.initialData['test'];
    timeController.text = widget.initialData['time'];
    dateController.text = widget.initialData['date'];
  }

  @override
  void dispose() {
    testController.dispose();
    timeController.dispose();
    dateController.dispose();
    super.dispose();
  }
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('update booking'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: const EdgeInsets.fromLTRB(25, 50, 25, 10),
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [

                  const SizedBox(height: 30,),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: testController,
                      readOnly: true,
                      onTap: _showMultiSelect,
                      decoration: ThemeHelper().textInputDecoration('test'),
                      // onChanged: (val){
                      //   setState(() {
                      //     widget.initialData['test'] = testController.text;
                      //   });
                      // },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller: dateController,
                      readOnly: true,
                      decoration: ThemeHelper().textInputDecoration("date"),
                      onTap: ()async{
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2030));

                        if (pickedDate != null) {
                          //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dateController.text = "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            widget.initialData['date'] = dateController.text;
                          });
                        }
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter your date";
                        }
                        return null;
                      },
                    ),
                  ),

                  const SizedBox(height: 20.0),
                  Container(
                    decoration: ThemeHelper().inputBoxDecorationShaddow(),
                    child: TextFormField(
                      controller:timeController,
                      decoration: ThemeHelper().textInputDecoration("time"),
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                      onTap: ()async{
                        var times = timeController.text.split('-');
                        TimeOfDay? pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(hour: int.parse(times[0]), minute: int.parse(times[1]))
                        );

                        if (pickedTime != null) {
                          setState(() {
                            timeController.text = "${pickedTime.hour}-${pickedTime.minute}"; //set output date to TextField value.
                            widget.initialData['time'] = timeController.text;
                          });
                        }
                      },
                      validator: (val) {
                        if(val!.isEmpty){
                          return "enter your time";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Container(
                    decoration: ThemeHelper().buttonBoxDecoration(context),
                    child: ElevatedButton(

                      style: ThemeHelper().buttonStyle(),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          "save".toUpperCase(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),

                      ),
                      onPressed: () async{
                        await updateAppointment(data: {
                          'test':testController.text,
                          'date':dateController.text,
                          'time':timeController.text,
                          'id':widget.initialData['id'],
                          'centreId':widget.initialData['centreId']
                        }).then((updated){
                          if(updated){
                            Navigator.pop(context);
                            // Provider.of<AuthChangeNotifier>(context,listen: false).notifyListeners();
                          }else{
                            Utils.showSnackbar(context: context, message: "failed to update");
                          }
                        });
                      },
                    ),

                  ),
                  const SizedBox(height: 30.0),
                  //Text("Or create account using social media",  style: TextStyle(color: Colors.grey),),
                  const SizedBox(height: 25.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 30.0,),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MultiSelect extends StatefulWidget {
  final List items;
  const MultiSelect({Key? key, required this.items}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final VideoPlayerController videoPlayerController =
  VideoPlayerController.asset("assets/image/sas.mp4");

  ChewieController? chewieController;

  // init State
  @override
  void initState() {
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 9 / 20,
      autoPlay: true,
      looping: true,
      autoInitialize: true,
      showControls: false,
    );
    super.initState();
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController!.dispose();
    super.dispose();
  }
  // this variable holds the selected items
  String? _selectedItem = "";

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue) {
    setState(() {
      _selectedItem = itemValue;
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItem);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => RadioListTile(
            value: item,
            groupValue: "the same value for all items",
            //  tileColor: Colors.red,
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (value) => _itemChange(value!),

          )
            ,

          )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
