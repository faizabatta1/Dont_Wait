
import 'package:dont_wait/login_page.dart';
import 'package:dont_wait/services/Authentication.dart';
import 'package:dont_wait/services/FirestoreService.dart';
import 'package:dont_wait/services/UserServices.dart';
import 'package:dont_wait/services/Utils.dart';
import 'package:dont_wait/services/centre.service.dart';
import 'package:dont_wait/table.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import 'Signup/ThemeHelper.dart';
import 'home_screen.dart';


class branches extends StatelessWidget {
  final Map<String,dynamic> data;
  final List<String> tests;
  const branches({Key? key, required this.data, required this.tests}) : super(key: key);

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
      home: HomePage(data:data,tests:tests),
    );
  }
}

// Multi Select widget
// This widget is reusable
class MultiSelect extends StatefulWidget {
  final List<String> items;
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
  final List<String> _selectedItems = [];

// This function is triggered when a checkbox is checked or unchecked
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  // this function is called when the Cancel button is pressed
  void _cancel() {
    Navigator.pop(context);
  }

// this function is called when the Submit button is tapped
  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(

      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(

          children: widget.items
              .map((item) => CheckboxListTile(
            value: _selectedItems.contains(item),
            title: Text(item),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (isChecked) => _itemChange(item, isChecked!),
          ))
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

// Implement a multi select on the Home screen
class HomePage extends StatefulWidget {
  final Map<String,dynamic> data;
  final List<String> tests;
  const HomePage({Key? key, required this.data, required this.tests}) : super(key: key);


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _selectedItems = [];

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
    'Nablus',
    'Qalqilya',
   ' Jenin',
   ' Tulkarm',
   ' Bethlehem',
    'Hebron',
    'Ramallah',
    'Gaza',
    'Jerusalem',
    'other....',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,


      ),

      body: SingleChildScrollView(
        child: Padding(

          padding: const EdgeInsets.all(40),
          child: Column(


            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // use this button to open the multi-select dialog
              ElevatedButton(
                onPressed: _showMultiSelect,
                // Text('Choose the types of medical tests you do'),
                child: Text(
                  "Choose places that contain all branches of your centers:",
                  style: TextStyle(
                    fontSize: 22.5,
                    fontFamily: 'ultra',
                    shadows: [
                      Shadow(
                          color: Colors.teal,
                          offset: Offset(0, -5))
                    ],
                    color: Colors.transparent,

                  ),
                ),

              ),

              const Divider(
                height: 40,
              ),
              // display selected items
              Wrap(
                children: _selectedItems
                    .map((e) => Chip(
                  label: Text(e),
                ))
                    .toList(),
              ),
              SizedBox(height: 300),
              Container(

                decoration: ThemeHelper().buttonBoxDecoration(context),
                child: ElevatedButton(
                  style: ThemeHelper().buttonStyle(),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                    child: Text('finish'.toUpperCase(), style: TextStyle(fontSize: 20,fontFamily: 'ultra' , color: Colors.white),),
                  ),
                  onPressed: ()async{
                    final hasPermission = await Utils.handleLocationPermission(context);
                    Map<String,dynamic> location = {};

                    if(hasPermission){
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);


                      print(position.latitude);
                      print(position.longitude);

                      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
                      Placemark place = placemarks[0];

                      location.addAll({
                        'latitude':position.latitude,
                        'longitude':position.longitude,
                        'place':'${place.street}, ${place.subLocality},${place.subAdministrativeArea}, ${place.postalCode}'
                      });
                    }

                    Map<String,dynamic> data = <String,dynamic>{
                      'tests': widget.tests,
                      'branches': _selectedItems,
                      'location':location
                    };
                    data.addAll(widget.data);
                    await addCentreToCheckPoint(data).then((value){
                      Utils.showSnackbar(context: context, message: "request submitted, check your email later");

                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
                        return LoginPage();
                      }));
                    });
                    //After successful login we will redirect to profile page. Let's create profile page now
                  },
                ),
              )

            ],

          ),


        ),
      ),

    );
  }
}